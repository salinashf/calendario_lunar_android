import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:geoengine/geoengine.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:moon_phase/moon_widget.dart';
import '../model/moon_phase_data.dart';
import 'package:dartx/dartx.dart';

class CarrucelCalendarPage extends StatefulWidget {
  const CarrucelCalendarPage({super.key, required this.titleHeader});

  final String titleHeader;

  @override
  State<CarrucelCalendarPage> createState() => CarrucelCalendarState();
}

class CarrucelCalendarState extends State<CarrucelCalendarPage> {
  String currentMonth = DateFormat.yMMM('es').format(DateTime.now());

  late List<ListTile> _currentWidgetPhaseMoonMap = [];
  final DateTime _markCurrentDate = DateTime.now();
  final EventList<Event> _markedDateMap = EventList<Event>(events: {});
  final DateTime _maxDateScroll = DateTime(DateTime.now().year, 12, 31);
  final DateTime _minDateScroll = DateTime(DateTime.now().year, 1, 1);
  DateTime _targetDateTime = DateTime.now();
  late final Map<DateTime, MoonPhaseData> _yearMoonPhaseMap = {};

  @override
  void initState() {
    DateTime startDate = DateTime(DateTime.now().year, 1, 1);
    DateTime endDate = DateTime.now().add(Duration(days: 360));
    while (startDate.year < endDate.year) {
      var moonData = MoonQuarter.searchMoonQuarter(startDate);
      MoonPhaseData datosFase = MoonPhaseData(
        quarter: moonData.quarter,
        fullTime: moonData.time,
        quarterIndex: moonData.quarterIndex,
      );
      _yearMoonPhaseMap[DateTime(
            moonData.time.date.year,
            moonData.time.date.month,
            moonData.time.date.day,
          )] =
          datosFase;
      startDate = moonData.time.date.add(Duration(days: 1));
    }
    _yearMoonPhaseMap.forEach((fecha, datos) {
      DateTime eventDate = DateTime(fecha.year, fecha.month, fecha.day);
      //debugPrint("--$eventDate---");
      _markedDateMap.add(
        eventDate,
        Event(
          date: eventDate,
          title: datos.quarter,
          icon: getEventMoonPhaseMain(datos.emoji, datos.quarterTlr, eventDate),
        ),
      );
    });
    loadTextWidgetCurrentPhase();
    super.initState();
  }

  String get titleHeaderParent => widget.titleHeader;

  // para la celda cuado  cae en alguna fase de la luna
  Widget getEventMoonPhaseMain(
    String emoji,
    String phaseName,
    DateTime dayPhase,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  phaseName,
                  style: TextStyle(
                    fontSize: constraints.maxHeight * 0.16,
                    color: Colors.amber, // Tamaño relativo
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  emoji,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF000000)),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1),
                    bottom: BorderSide(width: 2),
                  ),
                  color: Colors.blueAccent,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 0,
                  ),
                  child: Text(
                    DateFormat.MMMd('es').format(dayPhase).toString(),
                    style: TextStyle(
                      fontSize: constraints.maxHeight * 0.18,
                      color: Colors.yellow,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getBgCellMoonPhaseMain(DateTime dateCell) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            color: Colors.grey.shade600,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      },
    );
  }

  OutlinedBorder getBoderMoonPhaseMain() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
      side: BorderSide(color: Colors.blue.shade300, width: 1),
    );
  }

  // para la celda cuado no cae en ninguna fase de la luna
  Widget getMoonPhaseDefault(DateTime dateCell) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            // Asegura alineación
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: MoonWidget(
                  date: dateCell,
                  size: constraints.maxHeight * 0.52,
                ),
              ),
              AutoSizeText(
                dateCell.day.toString(),
                maxLines: 2,
                style: TextStyle(
                  fontSize: constraints.maxHeight * 0.14,
                  color: Colors.indigo[800], // Tamaño relativo
                ),
              ), // Espacio entre los textos
            ],
          ),
        );
      },
    );
  }

  void loadTextWidgetCurrentPhase() {
    //debugPrint("loadTextWidgetCurrentPhase $_targetDateTime");
    // Filtrar las fases lunares del mes y año actuales
    final filteredPhases = _yearMoonPhaseMap.filterKeys((key) {
      return key.year == _targetDateTime.year &&
          key.month == _targetDateTime.month;
    });

    // Mapear las fases filtradas a widgets ListTile
    _currentWidgetPhaseMoonMap =
        filteredPhases.entries.map((entry) {
          final keyDayMoon = entry.value;
          return ListTile(
            title: Text(
              keyDayMoon.quarterTlr,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              " ${DateFormat.yMMMMd('es').format(keyDayMoon.fullTime.date)}",
            ),
            leading: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(4),
              child: Text(
                keyDayMoon.emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        }).toList();
  }

  void lastMonthEvent() {
    setState(() {
      _targetDateTime = DateTime(
        _targetDateTime.year,
        _targetDateTime.month - 1,
      );
      currentMonth = DateFormat.yMMM('es').format(_targetDateTime);
      //debugPrint("XX XX lastMonthEvent  ");
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              titleHeaderParent,
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
                daysHaveCircularBorder: false,
                showOnlyCurrentMonthDate: false,
                thisMonthDayBorderColor: Colors.blueAccent,
                weekFormat: false,
                locale: 'es',
                firstDayOfWeek: 1,
                height: MediaQuery.of(context).size.height * 0.38,
                //width: 300.0,
                markedDatesMap: _markedDateMap,
                selectedDateTime: _markCurrentDate,
                targetDateTime: _targetDateTime,
                customGridViewPhysics: NeverScrollableScrollPhysics(),
                markedDateCustomShapeBorder: getBoderMoonPhaseMain(),
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
                            ? getBgCellMoonPhaseMain(dateCell)
                            : getMoonPhaseDefault(dateCell),
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
