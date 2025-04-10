import 'package:geoengine/geoengine.dart';

class MoonPhaseData {
  final String quarter;
  final AstroTime time;
  final int quarterIndex;
  late String emoji;
  late String quarter_tlr;
  // Constructor
  MoonPhaseData( {
    required this.quarter,
    required this.time,
    required this.quarterIndex
  }) {
    switch (this.quarterIndex) {
      case 0:
        emoji =  "🌕" ; //  new moon,
        quarter_tlr = "Luna Nueva";
      case 1:
        emoji =  "🌓" ; // Cuarto creciente
        quarter_tlr = "Cuarto creciente";
      case 2:
        emoji =  "🌑" ; // full moon
        quarter_tlr = "Luna Llena";
      case 3:
        emoji =  "🌗" ; // Cuarto menguante
        quarter_tlr = "Cuarto menguante";
      default:
        emoji =  "🌑" ; //  luna  genérica
        quarter_tlr = "Luna Generica";
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