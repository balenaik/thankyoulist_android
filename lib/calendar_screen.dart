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
      body: TableCalendar(
        calendarController: _calendarController,
        events: {DateTime.now(): ['event']},
        headerStyle: HeaderStyle(
          centerHeaderTitle: true,
          formatButtonVisible: false,
            formatButtonShowsNext: false,
          titleTextStyle: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
              fontSize: 20.0
          ),
          // TODO: Wait for `showLeftChevron`, `showRightChevron` property to be released to hide the buttons
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: Colors.black38,
            fontSize: 13.0,
            fontFamily: 'Nunito'
          ),
          weekendStyle: TextStyle(
            color: Colors.black38,
            fontSize: 13.0,
              fontFamily: 'Nunito'
          )
        ),
        calendarStyle: CalendarStyle(
            weekdayStyle: TextStyle(
                color: Colors.black87,
                fontSize: 17.0,
                fontFamily: 'Nunito'
            ),
          weekendStyle: TextStyle(
              color: Colors.black87,
              fontSize: 17.0,
              fontFamily: 'Nunito'
          ),
          outsideStyle: TextStyle(
              color: Colors.black38,
              fontSize: 17.0,
              fontFamily: 'Nunito'
          ),
          outsideWeekendStyle: TextStyle(
              color: Colors.black38,
              fontSize: 17.0,
              fontFamily: 'Nunito'
          ),
          contentPadding: EdgeInsets.only(bottom: 12.0, left: 8.0, right: 8.0),
          markersMaxAmount: 1,
        ),
        builders: CalendarBuilders(
          selectedDayBuilder: (context, date, _) {
            final isToday = date.day == DateTime.now().day;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.yellowAccent),
              margin: const EdgeInsets.all(12.0),
              alignment: Alignment.center,
              child: Text(
                '${date.day}',
                style: TextStyle(
                    color: isToday ? Colors.pinkAccent : Colors.black87,
                    fontSize: 17.0,
                    fontFamily: 'Nunito'
                ),
              ),
            );
          },
          todayDayBuilder: (context, date, _) {
            return Container(
              alignment: Alignment.center,
              child: Text(
                '${date.day}',
                 style: TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 17.0,
                    fontFamily: 'Nunito'
                ),
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
              Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: markers)
            ];
          },
        ),
      ),
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