import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:geoengine/geoengine.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../model/moon_phase_data.dart';

class CarrucelCalendarPage extends StatefulWidget {
  const CarrucelCalendarPage({super.key, required this.titleHeader});
  final String titleHeader;
  @override
  State<CarrucelCalendarPage> createState() => CarrucelCalendarState();
}

class CarrucelCalendarState extends State<CarrucelCalendarPage> {
  final DateTime _markCurrentDate = DateTime.now();
  final DateTime _minDateScroll = DateTime(DateTime.now().year, 1, 1);
  final DateTime _maxDateScroll = DateTime(DateTime.now().year, 12, 31);
  String currentMonth = DateFormat.yMMM('es').format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  late final Map<DateTime, MoonPhaseData> _yearMoonPhaseMap = {};
  late List<ListTile> _currentWidgetPhaseMoonMap = [];
  final EventList<Event> _markedDateMap = EventList<Event>(events: {});
  Widget getIconCell(String emoji) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              emoji,
              style: TextStyle(fontSize: constraints.maxHeight),
            ),
          ),
        );
      },
    );
  }

  Widget getIconCellPass(String emoji) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Text(emoji),
        );
      },
    );
  }

  Widget getIconMoonDefault() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 202, 193, 221),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  void loadTextWidgetCurrentPhase() {
    _currentWidgetPhaseMoonMap =
        _yearMoonPhaseMap.entries
            .where(
              (kfm) =>
                  kfm.key.year == _targetDateTime.year &&
                  kfm.key.month == _targetDateTime.month,
            )
            .map((entry) {
              final datav = entry.value;
              return ListTile(
                title: Text(
                  datav.quarterTlr,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  "Dia: ${datav.time.date.day} Mes: ${DateFormat.yMMM('es').format(datav.time.date)}",
                ),
                leading: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: EdgeInsets.all(4),
                  child: Text(datav.emoji, style: TextStyle(fontSize: 24)),
                ),
              );
            })
            .toList();
  }

  void lastMonthEvent() {
    setState(() {
      _targetDateTime = DateTime(
        _targetDateTime.year,
        _targetDateTime.month - 1,
      );
      currentMonth = DateFormat.yMMM('es').format(_targetDateTime);
      loadTextWidgetCurrentPhase();
    });
  }

  void nextMonthEvent() {
    setState(() {
      _targetDateTime = DateTime(
        _targetDateTime.year,
        _targetDateTime.month + 1,
      );
      currentMonth = DateFormat.yMMM('es').format(_targetDateTime);
      loadTextWidgetCurrentPhase();
    });
  }

  void calerdarScrollEvent(DateTime selectData) {
    setState(() {
      _targetDateTime = selectData;
      currentMonth = DateFormat.yMMM('es').format(_targetDateTime);
      loadTextWidgetCurrentPhase();
    });
  }

  @override
  void initState() {
    DateTime startDate = DateTime(DateTime.now().year, 1, 1);
    DateTime endDate = DateTime.now().add(Duration(days: 360));
    while (startDate.year < endDate.year) {
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
      debugPrint("--$eventDate---");
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Calendario Fase Lunar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat.yMMMM('es').format(_targetDateTime),
              style: TextStyle(
                fontSize: 14,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.double,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.yellowAccent,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: lastMonthEvent,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: nextMonthEvent,
          ),
        ],
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
                  left: BorderSide(width: 15.0, color: Colors.blueAccent),
                ),
              ),
              child: CalendarCarousel<Event>(
                todayBorderColor: Colors.green,
                daysHaveCircularBorder: true,
                showOnlyCurrentMonthDate: false,
                thisMonthDayBorderColor: Colors.grey,
                weekFormat: false,
                locale: 'es',
                firstDayOfWeek: 1,
                height: MediaQuery.of(context).size.height * 0.5,
                //width: 300.0,
                markedDatesMap: _markedDateMap,
                selectedDateTime: _markCurrentDate,
                targetDateTime: _targetDateTime,
                customGridViewPhysics: NeverScrollableScrollPhysics(),
                markedDateCustomShapeBorder: CircleBorder(
                  side: BorderSide(color: Colors.yellow),
                ),
                markedDateCustomTextStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
                weekendTextStyle: TextStyle(color: Colors.red),
                showHeader: false,
                todayTextStyle: TextStyle(color: Colors.blue),
                markedDateShowIcon: true,
                markedDateIconBuilder: (event) {
                  return Center(child: event.icon);
                },
                customDayBuilder: (
                  bool isSelectable,
                  int index,
                  bool isSelectedDay,
                  bool isToday,
                  bool isPrevMonthDay,
                  TextStyle textStyle,
                  bool isNextMonthDay,
                  bool isThisMonthDay,
                  DateTime dateCell,
                ) {
                  return Center(
                    child:
                        _yearMoonPhaseMap.entries
                                .where(
                                  (kfm) =>
                                      kfm.key.year == dateCell.year &&
                                      kfm.key.month == dateCell.month &&
                                      kfm.key.day == dateCell.day,
                                )
                                .isNotEmpty
                            ? getIconMoonDefault()
                            : Text(
                              dateCell.day.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                  );
                },

                todayButtonColor: Colors.yellow,
                selectedDayTextStyle: TextStyle(color: Colors.yellow),
                minSelectedDate: _minDateScroll,
                maxSelectedDate: _maxDateScroll,
                prevDaysTextStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.pinkAccent,
                ),
                inactiveDaysTextStyle: TextStyle(
                  color: Colors.tealAccent,
                  fontSize: 16,
                ),
                onCalendarChanged: (DateTime date) {
                  calerdarScrollEvent(date);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: const Border(
                  left: BorderSide(width: 15.0, color: Colors.redAccent),
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _currentWidgetPhaseMoonMap.length,
                itemBuilder: (context, index) {
                  return _currentWidgetPhaseMoonMap[index];
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
