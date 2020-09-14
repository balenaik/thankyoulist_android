import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:thankyoulist/models/thankyou_model.dart';
import 'package:thankyoulist/viewmodels/thankyou_calendar_view_model.dart';
import 'package:thankyoulist/views/common/thankyou_item.dart';
import 'package:thankyoulist/extensions/list_extension.dart';

final double _calendarPanelListViewBottomInset = 150.0;

class CalendarScreen extends StatelessWidget {
  CalendarController _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    ThankYouCalendarViewModel viewModel = Provider.of<ThankYouCalendarViewModel>(context, listen: true);
    List<ThankYouModel> selectedThankYous = viewModel.thankYouEvents[viewModel.selectedDate];

    return Scaffold(
      appBar: AppBar(
        title: Text('Thank You Calendar'),
      ),
      body: SlidingUpPanel(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0)
        ),
        maxHeight: MediaQuery.of(context).size.height,
        minHeight: MediaQuery.of(context).size.height * 0.3,
        panelBuilder: (scrollController) {
          return Column(
            children: <Widget>[
              _panelDateView(viewModel.selectedDate),
              Expanded(child:
                ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  // Returns count +1 because of a bug which the bottom of ListView is a little higher
                  itemCount: (selectedThankYous?.length ?? 0) + 1,
                  itemBuilder: (BuildContext context, int i) {
                    if (selectedThankYous.get(i) != null) {
                      return ThankYouItem(
                          thankYou: selectedThankYous.get(i)
                      );
                    } else {
                      // Adjust for a bug which the bottom of ListView is a little higher
                      return SizedBox(height: _calendarPanelListViewBottomInset);
                    }
                  })
              ),
            ],
          );
        },
        body: TableCalendar(
          calendarController: _calendarController,
          events: viewModel.thankYouEvents,
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
          onDaySelected: (date, events) {
            // Since date here always returns XXXX-XX-XX 12:00:00.000Z, remove 12 hours
            DateTime adjustedDate = date.add(Duration(hours: -12));
            viewModel.updateSelectedDate(adjustedDate);
          },
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

  Widget _panelDateView(DateTime date) {
    return Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0)
                ),
                color: Colors.yellowAccent,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, 1.5),
                      blurRadius: 1
                  )
                ]
            ),
            height: 60,
            child: Center(child: Text(DateFormat("yyyy/MM/dd").format(date)),),
          ),
          SizedBox(
              height: 3.0
          )
        ]
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