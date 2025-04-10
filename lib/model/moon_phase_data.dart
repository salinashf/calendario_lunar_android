import 'package:geoengine/geoengine.dart' show AstroTime;

class MoonPhaseData {
  final String quarter;
  final AstroTime time;
  final int quarterIndex;
  late String emoji;
  late String quarterTlr;
  // Constructor
  MoonPhaseData({
    required this.quarter,
    required this.time,
    required this.quarterIndex,
  }) {
    switch (quarterIndex) {
      case 0:
        emoji = "🌕"; //  new moon,
        quarterTlr = "Luna Nueva";
      case 1:
        emoji = "🌓"; // Cuarto creciente
        quarterTlr = "Cuarto creciente";
      case 2:
        emoji = "🌑"; // full moon
        quarterTlr = "Luna Llena";
      case 3:
        emoji = "🌗"; // Cuarto menguante
        quarterTlr = "Cuarto menguante";
      default:
        emoji = "🌑"; //  luna  genérica
        quarterTlr = "Luna Generica";
    }

    ///      0 = new moon,
    ///      1 = first quarter,
    ///      2 = full moon,
    ///      3 = third quarter.
  }
  @override
  String toString() {
    return 'Quarter: $quarter, Time: $time.date.toString(), QuarterIndex: $quarterIndex';
  }
}
