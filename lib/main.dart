import 'package:flutter/material.dart';
import 'componets/CarrucelCalendar.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const CarrucelCalendarPage(titleHeader: 'Calendario Lunar'),
    );
  }
}
