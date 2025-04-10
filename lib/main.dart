import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'componets/calendar_custom.dart';

void main() {
  initializeDateFormatting('es_EC', null).then((_) => runApp(const App()));
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fases Lunares',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const CarrucelCalendarPage(titleHeader: 'Calendario Lunar'),
    );
  }
}
