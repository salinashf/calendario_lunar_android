import 'package:geoengine/geoengine.dart' show AstroTime;

class MoonPhaseData {
  final String quarter;
  final AstroTime fullTime;
  final int quarterIndex;
  late String emoji;
  late String quarterTlr;
  // Constructor
  MoonPhaseData({
    required this.quarter,
    required this.fullTime,
    required this.quarterIndex,
  }) {
    switch (quarterIndex) {
      case 0:
        emoji = "🌑"; //  new moon,
        quarterTlr = "Luna Nueva";
      case 1:
        emoji = "🌓"; // Cuarto creciente
        quarterTlr = "Creciente";
      case 2:
        emoji = "🌕"; // full moon
        quarterTlr = "Luna Llena";
      case 3:
        emoji = "🌗"; // Cuarto menguante
        quarterTlr = "Menguante";
      default:
        emoji = "🌑"; //  luna  genérica
        quarterTlr = "Genérica";
    }

    ///      0 = new moon,
    ///      1 = first quarter,
    ///      2 = full moon,
    ///      3 = third quarter.
  }
  @override
  String toString() {
    return 'Quarter Moon : $quarter => Time: $fullTime.date.toString() => QuarterIndex: $quarterIndex';
  }
}
