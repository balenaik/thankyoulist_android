import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatelessWidget {
  CalendarController _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thank You Calendar'),
      ),
      body: Stack(children: [
        TableCalendar(
          calendarController: _calendarController,
          events: {
            DateTime.now(): ['event']
          },
          headerStyle: HeaderStyle(
            centerHeaderTitle: true,
            formatButtonVisible: false,
            formatButtonShowsNext: false,
            titleTextStyle: TextStyle(
                color: Colors.brown,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
            // TODO: Wait for `showLeftChevron`, `showRightChevron` property to be released to hide the buttons
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: _dayTextStyle(color: Colors.black38),
              weekendStyle: _dayTextStyle(color: Colors.black38)),
          calendarStyle: CalendarStyle(
            weekdayStyle: _dayTextStyle(color: Colors.black87),
            weekendStyle: _dayTextStyle(color: Colors.black87),
            outsideStyle: _dayTextStyle(color: Colors.black38),
            outsideWeekendStyle: _dayTextStyle(color: Colors.black38),
            contentPadding:
                EdgeInsets.only(bottom: 12.0, left: 8.0, right: 8.0),
            markersMaxAmount: 1,
          ),
          builders: CalendarBuilders(
            selectedDayBuilder: (context, date, _) {
              final isToday = date.day == DateTime.now().day;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.yellowAccent),
                margin: const EdgeInsets.all(12.0),
                alignment: Alignment.center,
                child: Text(
                  '${date.day}',
                  style: _dayTextStyle(
                      color: isToday ? Colors.pinkAccent : Colors.black87),
                ),
              );
            },
            todayDayBuilder: (context, date, _) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  '${date.day}',
                  style: _dayTextStyle(color: Colors.pinkAccent),
                ),
              );
            },
            markersBuilder: (context, date, events, holidays) {
              final eventsCount = events.length;
              List<Widget> markers = [];
              if (eventsCount > 0) {
                markers.add(_marker());
              }
              if (eventsCount > 1) {
                markers.add(_marker());
              }
              if (eventsCount == 3) {
                markers.add(_marker());
              } else if (eventsCount > 3) {
                markers.add(_moreMarker());
              }
              return [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: markers)
              ];
            },
          ),
        ),
        DraggableScrollableSheet(
          minChildSize: 0.35,
          initialChildSize: 0.35,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30.0)),
                color: Colors.teal[200],
              ),
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: 25,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(title : Text('Item $index'),);
                  }),
            );
          }
        )
      ]),
    );
  }

  TextStyle _dayTextStyle({color: Color}) {
    return TextStyle(
        color: color,
        fontSize: 17.0,
        fontFamily: 'Nunito'
    );
  }

  Widget _marker() {
    return Container(
        width: 10.0,
        height: 10.0,
        color: Colors.red[700],
        margin: const EdgeInsets.symmetric(horizontal: 1.5)
    );
  }

  Widget _moreMarker() {
    return Container(
        width: 10.0,
        height: 10.0,
        color: Colors.red[700],
        margin: const EdgeInsets.symmetric(horizontal: 1.5)
    );
  }
}