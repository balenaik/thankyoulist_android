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
          singleMarkerBuilder:  (context, date, event) {
            final color = Colors.red[700];

            return Container(
              width: 10.0,
              height: 10.0,
              color: color,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
            );
          },
        ),
      ),
    );
  }
}