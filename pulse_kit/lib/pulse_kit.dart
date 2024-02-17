library pulse_kit;

export 'models/pulse_result.dart';
export 'models/pulse_types.dart';
export 'models/pulse_workout_reading.dart';
export 'models/pulse_workout_types.dart';

import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pulse_kit/models/pulse_result.dart';
import 'package:pulse_kit/models/pulse_types.dart';
import 'package:pulse_kit/models/pulse_workout_reading.dart';
import 'package:pulse_kit/models/pulse_workout_types.dart';

/// PulseKit is a class for managing and tracking fitness sessions.
/// It interfaces with the native platform to collect workout data.
class PulseKit {
  static const _channel = MethodChannel('pulse');
  final _controller = StreamController<PulseWorkoutReading>.broadcast();

  var _workoutTypes = <PulseWorkoutType>[];

  /// Stream of [PulseWorkoutReading] which provides updates during a workout session.
  Stream<PulseWorkoutReading> get stream => _controller.stream;

  /// Constructor initializes the PulseKit and sets up the method call handler.
  PulseKit() {
    _channel.setMethodCallHandler(_handleMessage);
  }

  final _activityRecognitionFeatures = {
    PulseWorkoutType.calories,
    PulseWorkoutType.steps,
    PulseWorkoutType.distance,
    PulseWorkoutType.speed
  };

  /// Retrieves the supported exercise types from the native platform.
  /// Returns a list of [PulseType] which represents various supported exercise types.
  Future<List<PulseType>> getSupportedExerciseTypes() async {
    if (!Platform.isAndroid) return [];

    final result = await _channel.invokeListMethod<int>('getSupportedExercises');
    final types = <PulseType>[];
    for (final id in result!) {
      final type = PulseType.fromId(id);
      if (type != PulseType.unknown) {
        types.add(type);
      }
    }
    return types;
  }

  /// Starts a PulseKit session with specified features.
  /// Uses GPS for distance/speed estimation if [enableGps] is true and permission is granted.
  /// Returns a [PulseResult] indicating the status of the workout session initiation.
  Future<PulseResult> start({
    required PulseType exerciseType,
    required List<PulseWorkoutType> features,
    bool enableGps = false,
  }) async {
    _workoutTypes = features;
    return _initPulseForWearOS(exerciseType: exerciseType, enableGps: enableGps);
  }

  /// Stops the PulseKit session and halts sensor data collection.
  Future<void> stop() async => await _channel.invokeMethod<void>('stopExercise');

  /// Handles the specific implementation for starting a PulseKit session on Android.
  /// Requests necessary permissions and prepares the sensor configuration.
  Future<PulseResult> _initPulseForWearOS({
    required PulseType exerciseType,
    required bool enableGps,
  }) async {
    final sensors = await _prepareSensors();
    if (enableGps) {
      final status = await Permission.location.request();
      if (!status.isGranted) {
        enableGps = false;
      }
    }

    return _startListening(
      exerciseType: exerciseType,
      sensors: sensors,
      enableGps: enableGps,
    );
  }

  /// Initiates a workout session with the given configuration.
  Future<PulseResult> _startListening({
    required PulseType? exerciseType,
    required List<String> sensors,
    required bool enableGps,
  }) async {
    final result = await _channel.invokeMapMethod<String, dynamic>(
      'startExercise',
      {'exerciseType': exerciseType?.id, 'sensors': sensors, 'enableGps': enableGps},
    );
    return PulseResult.generate(result);
  }

  /// Prepares the list of sensors based on the current features and requested permissions.
  Future<List<String>> _prepareSensors() async {
    final sensors = <String>[];

    if (_workoutTypes.contains(PulseWorkoutType.heartRate)) {
      final status = await Permission.sensors.request();
      if (status.isGranted) sensors.add(PulseWorkoutType.heartRate.name);
    }

    final requestedActivityRecognitionFeatures =
        _workoutTypes.toSet().intersection(_activityRecognitionFeatures);
    if (requestedActivityRecognitionFeatures.isNotEmpty) {
      final status = await Permission.activityRecognition.request();
      if (status.isGranted) {
        sensors.addAll(requestedActivityRecognitionFeatures.map((e) => e.name));
      }
    }
    return sensors;
  }

  /// Handles incoming method calls from the native platform.
  /// Updates the stream with new workout readings.
  Future<dynamic> _handleMessage(MethodCall call) {
    try {
      final arguments = call.arguments as List<dynamic>;
      final workoutTypeString = arguments[0] as String;
      final value = arguments[1] as double;
      final timestamp = arguments[2] as int?;

      if (!_workoutTypes.map((e) => e.name).contains(workoutTypeString)) {
        return Future.value();
      }

      final workoutType = PulseWorkoutType.values.byName(workoutTypeString);
      _controller.add(PulseWorkoutReading(workoutType, value, timestamp: timestamp));
      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
  }
}
