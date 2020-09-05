import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:thankyoulist/models/thankyou_model.dart';

class CalendarScreen extends StatelessWidget {
  CalendarController _calendarController = CalendarController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String userId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _getThankYouList(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
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
                    events: Map.fromIterable(snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      ThankYouModel thankYou = ThankYouModel.fromJson(
                          json: document.data,
                          documentId: document.documentID,
                          userId: userId);
                      return thankYou;
                    }), key: (e) => e.date, value: (e) => [e.value]),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: markers)
                        ];
                      },
                    ),
                  ),
                ),
              );
          }
        });
  }

  Stream<QuerySnapshot> _getThankYouList() async* {
    FirebaseUser user = await auth.currentUser();
    userId = user.uid;
    var snapshots = Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('thankYouList')
        .snapshots();
    yield* snapshots;
  }

  TextStyle _dayTextStyle({color: Color}) {
    return TextStyle(color: color, fontSize: 17.0, fontFamily: 'Nunito');
  }

  Widget _marker() {
    return Container(
        width: 10.0,
        height: 10.0,
        color: Colors.red[700],
        margin: const EdgeInsets.symmetric(horizontal: 1.5));
  }

  Widget _moreMarker() {
    return Container(
        width: 10.0,
        height: 10.0,
        color: Colors.red[700],
        margin: const EdgeInsets.symmetric(horizontal: 1.5));
  }
}
