import 'package:pulse_kit/models/pulse_workout_types.dart';

/// Represents a single sensor reading related to a workout, collected from a wearable device like a smartwatch.
class PulseWorkoutReading {
  /// The timestamp when the reading was recorded. Defaults to the current time if not provided.
  final DateTime timestamp;

  /// The type of workout data this reading represents, such as heart rate, calories, etc.
  final PulseWorkoutType feature;

  /// The numeric value of the reading. The meaning of this value depends on the [feature].
  final double value;

  /// Constructs a [PulseWorkoutReading] with the given [feature], [value], and optional [timestamp].
  /// If [timestamp] is not provided, the current time is used.
  PulseWorkoutReading(this.feature, this.value, {int? timestamp})
      : timestamp = timestamp != null
            ? DateTime.fromMillisecondsSinceEpoch(timestamp)
            : DateTime.now();
}
