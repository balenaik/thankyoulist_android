import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:thankyoulist/viewmodels/thankyoulist_view_model.dart';

class CalendarScreen extends StatelessWidget {
  CalendarController _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    ThankYouListViewModel viewModel = Provider.of<ThankYouListViewModel>(context, listen: true);
    Map<DateTime,  List<String>> eventMap = {};
    viewModel.thankYouList.forEach((thankYou) {
      eventMap[thankYou.date] ??= List<String>();
      eventMap[thankYou.date].add(thankYou.value);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Thank You Calendar'),
      ),
      body: SlidingUpPanel(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0)),
        maxHeight: MediaQuery.of(context).size.height,
        minHeight: MediaQuery.of(context).size.height * 0.3,
        panelBuilder: (scrollController) {
          return ListView.builder(
              controller: scrollController,
              itemCount: 50,
              itemBuilder: (BuildContext context, int i) {
                return Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("$i"),
                );
              });
        },
        body: TableCalendar(
          calendarController: _calendarController,
          events: eventMap,
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
                    shape: BoxShape.circle,
                    color: Colors.yellowAccent),
                margin: const EdgeInsets.all(12.0),
                alignment: Alignment.center,
                child: Text(
                  '${date.day}',
                  style: _dayTextStyle(
                      color: isToday
                          ? Colors.pinkAccent
                          : Colors.black87),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: markers
                )
              ];
            },
          ),
        ),
      ),
    );
  }

  TextStyle _dayTextStyle({color: Color}) {
    return TextStyle(color: color, fontSize: 17.0, fontFamily: 'Nunito');
  }

  Widget _marker() {
    return SizedBox(
      width: 5.0,
      height: 5.0,
      child: CircleAvatar(
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _moreMarker() {
    return Icon(
      Icons.add,
      color: Colors.red,
      size: 10.0,
    );
  }
}
