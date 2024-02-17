/// Enum representing different types of data that can be measured or estimated during a workout.
/// Each type corresponds to a specific aspect of workout tracking.
enum PulseWorkoutType {
  /// Represents an unknown workout feature.
  /// Used when the workout data type is not recognized or not available.
  unknown,

  /// Represents the heart rate of the individual during the workout.
  /// Measured in beats per minute (BPM).
  heartRate,

  /// Represents the estimated number of calories burned during the workout.
  /// This is typically calculated based on various factors like duration, intensity, and the individual's biometrics.
  calories,

  /// Represents the number of steps taken by the individual during the workout.
  /// This is particularly relevant for activities like walking, running, and hiking.
  steps,

  /// Represents the total distance traveled during the workout.
  /// Measured in meters. Useful for tracking performance in activities such as running, biking, and swimming.
  distance,

  /// Represents the speed of the individual during the workout.
  /// Measured in meters per second (m/s). It is a key metric for activities like running, cycling, and skating.
  speed,
}
