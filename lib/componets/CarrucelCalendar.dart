import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:geoengine/geoengine.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../model/MoonPhaseData.dart';

class CarrucelCalendarPage extends StatefulWidget {
  const CarrucelCalendarPage({super.key, required this.titleHeader});
  final String titleHeader;
  @override
  State<CarrucelCalendarPage> createState() => CarrucelCalendarState();
}

class CarrucelCalendarState extends State<CarrucelCalendarPage> {
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  late Map<DateTime, MoonPhaseData> _yearMoonPhaseMap = {};
  late List<ListTile> _currentWidgetPhaseMoonMap = [];
  final EventList<Event> _markedDateMap = EventList<Event>(events: {});
  static const TextStyle txtStylelabelMoon = TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
  Widget getIconCell(String emoji) {
    return DecoratedBox(
      decoration: BoxDecoration(
        //color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.purple, width: 10),
      ),
      child: Center(child: Text(emoji, style: TextStyle(fontSize: 24))),
    );
  }

  @override
  void initState() {
    // se carga las fases lunares para todo el anio
    DateTime startDate = _targetDateTime;
    DateTime endDate = _targetDateTime;
    while (startDate.year <= endDate.year + 1) {
      var moonData = MoonQuarter.searchMoonQuarter(startDate);
      MoonPhaseData datosFase = MoonPhaseData(
        quarter: moonData.quarter,
        time: moonData.time,
        quarterIndex: moonData.quarterIndex,
      );
      _yearMoonPhaseMap[startDate] = datosFase;
      startDate = moonData.time.date.add(Duration(days: 1));
    }
    _yearMoonPhaseMap.forEach((fecha, datos) {
      DateTime eventDate = DateTime(fecha.year, fecha.month, fecha.day);
      _markedDateMap.add(
        eventDate,
        Event(
          date: eventDate,
          title: datos.quarter,
          icon: getIconCell(datos.emoji),
        ),
      );
    });
    loadTextWidgetCurrentPhase();
  }

  loadTextWidgetCurrentPhase() {
    _currentWidgetPhaseMoonMap =
        _yearMoonPhaseMap.entries
            .where(
              (kfm) =>
                  kfm.key.year == _targetDateTime!.year &&
                  kfm.key.month == _targetDateTime!.month,
            )
            .map((entry) {
              final datek = entry.key;
              final datav = entry.value;
              return ListTile(
                title: Text(
                  datav.quarter_tlr,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text("Dia: ${datav.time.date.day}"),
                leading: Text(datav.emoji),
              );
            })
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    final calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.green,
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      locale: 'es',
      firstDayOfWeek: 1,
      height: 350,
      markedDatesMap: _markedDateMap,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder: CircleBorder(
        side: BorderSide(color: Colors.yellow),
      ),
      markedDateCustomTextStyle: TextStyle(fontSize: 18, color: Colors.blue),
      weekendTextStyle: TextStyle(color: Colors.red),
      showHeader: false,
      todayTextStyle: TextStyle(color: Colors.blue),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      markedDateMoreShowTotal: true,
      customDayBuilder: (
        bool isSelectable,
        int index,
        bool isSelectedDay,
        bool isToday,
        bool isPrevMonthDay,
        TextStyle textStyle,
        bool isNextMonthDay,
        bool isThisMonthDay,
        DateTime day,
      ) {
        return Center(child: Text(day.day.toString()));
      },
      todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(color: Colors.yellow),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(fontSize: 16, color: Colors.pinkAccent),
      inactiveDaysTextStyle: TextStyle(color: Colors.tealAccent, fontSize: 16),
      onCalendarChanged: (DateTime date) {
        setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM('es').format(_targetDateTime);
        });
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titleHeader),
        backgroundColor: Colors.yellowAccent,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                border: const Border(
                  left: BorderSide(width: 15.0, color: Colors.yellow),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _currentMonth,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: Text('ATRAS'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.amber,
                      side: BorderSide(color: Colors.purpleAccent),
                    ),
                    onPressed: () {
                      setState(() {
                        _targetDateTime = DateTime(
                          _targetDateTime.year,
                          _targetDateTime.month - 1,
                        );
                        _currentMonth = DateFormat.yMMM(
                          'es',
                        ).format(_targetDateTime);

                        loadTextWidgetCurrentPhase();
                        _currentWidgetPhaseMoonMap.forEach((valores) {});
                      });
                    },
                  ),
                  TextButton(
                    child: Text('ADELANTE'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.amber,
                      side: BorderSide(color: Colors.purpleAccent),
                    ),
                    onPressed: () {
                      setState(() {
                        _targetDateTime = DateTime(
                          _targetDateTime.year,
                          _targetDateTime.month + 1,
                        );
                        _currentMonth = DateFormat.yMMM(
                          'es',
                        ).format(_targetDateTime);
                        loadTextWidgetCurrentPhase();
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                border: const Border(
                  left: BorderSide(width: 15.0, color: Colors.blueAccent),
                ),
              ),
              child: calendarCarouselNoHeader,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: const Border(
                  left: BorderSide(width: 15.0, color: Colors.redAccent),
                ),
              ),
              child: SizedBox(
                child: Card(
                  child: Column(children: _currentWidgetPhaseMoonMap),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
