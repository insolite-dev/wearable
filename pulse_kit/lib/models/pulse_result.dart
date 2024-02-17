import 'package:pulse_kit/models/pulse_workout_types.dart';

/// Represents the outcome of attempting to start a workout session.
/// This class provides details about the session's initialization,
/// including any workout features that might not be supported by the device.
class PulseResult {
  /// A list of workout features that are unsupported by the device.
  ///
  /// For Wear OS devices, this list includes features requested but unsupported for the given exercise type.
  /// For Tizen devices, this list is always empty as all requested features are supported.
  final List<PulseWorkoutType> unsupportedWorkoutTypes;

  /// A private constructor for [PulseResult] to initialize [unsupportedFeatures].
  PulseResult._({required this.unsupportedWorkoutTypes});

  /// Creates an empty [PulseResult] with no unsupported features.
  /// This is typically used for platforms where unsupported features are not applicable.
  PulseResult._empty() : this._(unsupportedWorkoutTypes: []);

  /// Constructs a [PulseResult] from a map representation of the result.
  ///
  /// This factory constructor parses the map [result] to extract information about unsupported features.
  /// If [result] is null, or does not contain information about unsupported features,
  /// an empty [PulseResult] is returned.
  factory PulseResult.generate(Map<String, dynamic>? result) {
    if (result == null) return PulseResult._empty();

    final unsupportedWorkoutTypes = result['unsupportedWorkoutTypes'] as List?;
    final List<PulseWorkoutType> unsupportedFeatures = unsupportedWorkoutTypes != null
        ? unsupportedWorkoutTypes.cast<String>().map(PulseWorkoutType.values.byName).toList()
        : [];

    return PulseResult._(unsupportedWorkoutTypes: unsupportedFeatures);
  }
}
