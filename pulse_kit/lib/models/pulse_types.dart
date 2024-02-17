/// Exercise types for Wear OS.
/// Enumerates various exercise types with their associated identifiers,
/// used for tracking and identifying different forms of physical activities.
enum PulseType {
  /// Represents an unknown exercise type.
  unknown(0),

  /// Represents the back extension exercise.
  backExtension(1),

  /// Represents the badminton sport.
  badminton(2),

  /// Represents the barbell shoulder press exercise.
  barbellShoulderPress(3),

  /// Represents the baseball sport.
  baseball(4),

  /// Represents the basketball sport.
  basketball(5),

  /// Represents the bench press exercise.
  benchPress(6),

  /// Represents the bench sit-up exercise.
  benchSitUp(7),

  /// Represents biking.
  biking(8),

  /// Represents stationary biking.
  bikingStationary(9),

  /// Represents boot camp workout.
  bootCamp(10),

  /// Represents boxing.
  boxing(11),

  /// Represents burpee exercise.
  burpee(12),

  /// Represents calisthenics.
  calisthenics(13),

  /// Represents the cricket sport.
  cricket(14),

  /// Represents crunch exercise.
  crunch(15),

  /// Represents dancing.
  dancing(16),

  /// Represents deadlift exercise.
  deadlift(17),

  /// Represents dumbbell curl with right arm.
  dumbbellCurlRightArm(18),

  /// Represents dumbbell curl with left arm.
  dumbbellCurlLeftArm(19),

  /// Represents dumbbell front raise exercise.
  dumbbellFrontRaise(20),

  /// Represents dumbbell lateral raise exercise.
  dumbbellLateralRaise(21),

  /// Represents dumbbell triceps extension with left arm.
  dumbbellTricepsExtensionLeftArm(22),

  /// Represents dumbbell triceps extension with right arm.
  dumbbellTricepsExtensionRightArm(23),

  /// Represents dumbbell triceps extension with both arms.
  dumbbellTricepsExtensionTwoArm(24),

  /// Represents exercising on an elliptical machine.
  elliptical(25),

  /// Represents a general exercise class.
  exerciseClass(26),

  /// Represents the fencing sport.
  fencing(27),

  /// Represents playing with a frisbee disc.
  frisbeeDisc(28),

  /// Represents American football.
  footballAmerican(29),

  /// Represents Australian football.
  footballAustralian(30),

  /// Represents the forward twist exercise.
  forwardTwist(31),

  /// Represents the golf sport.
  golf(32),

  /// Represents guided breathing exercise.
  guidedBreathing(33),

  /// Represents gymnastics.
  gymnastics(34),

  /// Represents handball.
  handball(35),

  /// Represents high-intensity interval training.
  highIntensityIntervalTraining(36),

  /// Represents hiking.
  hiking(37),

  /// Represents ice hockey.
  iceHockey(38),

  /// Represents ice skating.
  iceSkating(39),

  /// Represents jump rope exercise.
  jumpRope(40),

  /// Represents jumping jacks.
  jumpingJack(41),

  /// Represents lat pull-down exercise.
  latPullDown(42),

  /// Represents lunge exercise.
  lunge(43),

  /// Represents martial arts.
  martialArts(44),

  /// Represents meditation.
  meditation(45),

  /// Represents paddling.
  paddling(46),

  /// Represents para gliding.
  paraGliding(47),

  /// Represents pilates.
  pilates(48),

  /// Represents plank exercise.
  plank(49),

  /// Represents racquetball.
  racquetball(50),

  /// Represents rock climbing.
  rockClimbing(51),

  /// Represents roller hockey.
  rollerHockey(52),

  /// Represents rowing.
  rowing(53),

  /// Represents exercising on a rowing machine.
  rowingMachine(54),

  /// Represents running.
  running(55),

  /// Represents running on a treadmill.
  runningTreadmill(56),

  /// Represents rugby.
  rugby(57),

  /// Represents sailing.
  sailing(58),

  /// Represents scuba diving.
  scubaDiving(59),

  /// Represents skating.
  skating(60),

  /// Represents skiing.
  skiing(61),

  /// Represents snowboarding.
  snowboarding(62),

  /// Represents snowshoeing.
  snowshoeing(63),

  /// Represents soccer.
  soccer(64),

  /// Represents softball.
  softball(65),

  /// Represents squash.
  squash(66),

  /// Represents squat exercise.
  squat(67),

  /// Represents stair climbing.
  stairClimbing(68),

  /// Represents exercising on a stair climbing machine.
  stairClimbingMachine(69),

  /// Represents strength training.
  strengthTraining(70),

  /// Represents stretching exercise.
  stretching(71),

  /// Represents surfing.
  surfing(72),

  /// Represents open water swimming.
  swimmingOpenWater(73),

  /// Represents swimming in a pool.
  swimmingPool(74),

  /// Represents table tennis.
  tableTennis(75),

  /// Represents tennis.
  tennis(76),

  /// Represents upper twist exercise.
  upperTwist(77),

  /// Represents volleyball.
  volleyball(78),

  /// Represents walking.
  walking(79),

  /// Represents water polo.
  waterPolo(80),

  /// Represents weightlifting.
  weightlifting(81),

  /// Represents a general workout.
  workout(82),

  /// Represents yoga.
  yoga(83),

  /// Represents backpacking.
  backpacking(84),

  /// Represents mountain biking.
  mountainBiking(85),

  /// Represents orienteering.
  orienteering(86),

  /// Represents inline skating.
  inlineSkating(87),

  /// Represents horse riding.
  horseRiding(88),

  /// Represents roller skating.
  rollerSkating(89),

  /// Represents yachting.
  yachting(90),

  /// Represents cross-country skiing.
  crossCountrySkiing(91),

  /// Represents alpine skiing.
  alpineSkiing(92);

  /// The numeric ID associated with the exercise type.
  final int id;

  /// Constructs an instance of [PulseType] with the given ID.
  const PulseType(this.id);

  /// Returns the [PulseType] corresponding to the provided [id], or [PulseType.unknown] if no match is found.
  static PulseType fromId(int id) => PulseType.values.firstWhere((e) => e.id == id, orElse: () => PulseType.unknown);
}
