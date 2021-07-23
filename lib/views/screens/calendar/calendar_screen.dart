import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:thankyoulist/app_colors.dart';
import 'package:thankyoulist/gen/assets.gen.dart';
import 'package:thankyoulist/gen/fonts.gen.dart';

import 'package:thankyoulist/models/thankyou_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/thankyoulist_repository.dart';
import 'package:thankyoulist/viewmodels/thankyou_calendar_view_model.dart';
import 'package:thankyoulist/views/common/thankyou_item.dart';
import 'package:thankyoulist/extensions/list_extension.dart';
import 'package:thankyoulist/views/common/remove_glowingover_scrollindicator_behavior.dart';
import 'package:thankyoulist/views/screens/edit_thankyou/edit_thankyou_screen.dart';
import 'package:thankyoulist/views/screens/my_page/my_page_screen.dart';
import 'package:thankyoulist/views/themes/light_theme.dart';

final double _calendarPanelListViewBottomInset = 150.0;

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThankYouCalendarViewModel>.value(
        value: ThankYouCalendarViewModel(
          Provider.of<ThankYouListRepositoryImpl>(context, listen: false),
          Provider.of<AuthRepositoryImpl>(context, listen: false),
        ),
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Thank You Calendar',
                style: TextStyle(
                    color: primaryColor[900],
                    fontWeight: FontWeight.bold
                ),
              ),
              centerTitle: true,
              shape: Border(bottom: BorderSide(color: Colors.black12)),
              elevation: 0,
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: Assets.icons.accountCircle20.image(color: Theme.of(context).primaryColor),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyPageScreen(),
                          fullscreenDialog: true
                      ),
                    );
                  },
                )
              ],
            ),
            backgroundColor: Colors.grey[100],
            body: CalendarSlidingUpPanel()
        )
    );
  }
}

class CalendarSlidingUpPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThankYouCalendarViewModel viewModel = Provider.of<ThankYouCalendarViewModel>(context, listen: true);
    List<ThankYouModel>? selectedThankYous = viewModel.thankYouEvents[viewModel.selectedDate];
    return SlidingUpPanel(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0)
      ),
      boxShadow: <BoxShadow>[], // Delete shadow
      maxHeight: MediaQuery.of(context).size.height,
      minHeight: MediaQuery.of(context).size.height * 0.3,
      color: Colors.white,
      panelBuilder: (scrollController) {
        return Column(
          children: <Widget>[
            _panelDateView(viewModel.selectedDate),
            Expanded(
                child: ScrollConfiguration(
                    behavior: RemoveGlowingOverScrollIndicatorBehavior(),
                    child: ListView.builder(
                        controller: scrollController,
                        scrollDirection: Axis.vertical,
                        // Returns count +1 because of a bug which the bottom of ListView is a little higher
                        itemCount: (selectedThankYous?.length ?? 0) + 1,
                        itemBuilder: (BuildContext context, int i) {
                          final thankYou = selectedThankYous?.get(i);
                          if (thankYou != null) {
                            return ThankYouItem(
                              thankYou: thankYou,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => EditThankYouScreen(thankYou.id),
                                      fullscreenDialog: true
                                  ),
                                );
                              },
                            );
                          } else {
                            // Adjust for a bug which the bottom of ListView is a little higher
                            return SizedBox(height: _calendarPanelListViewBottomInset);
                          }
                        })
                )
            ),
          ],
        );
      },
      body: CalendarScreenBaseCalendar(),
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
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 0.5),
                      blurRadius: 2
                  )
                ]
            ),
            height: 60,
            child: Center(
              child: Text(
                DateFormat.yMMMMd('en_US').format(date),
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: FontFamily.nunito,
                    fontWeight: FontWeight.w400
                ),

              ),
            ),
          ),
          SizedBox(
              height: 3.0
          )
        ]
    );
  }
}

class CalendarScreenBaseCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThankYouCalendarViewModel viewModel = Provider.of<ThankYouCalendarViewModel>(context, listen: true);
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TableCalendar(
        focusedDay: DateTime.now(),
        firstDay: DateTime(2015),
        lastDay: DateTime(2050),
        eventLoader: viewModel.getThankYouEvents,
        headerStyle: HeaderStyle(
          headerMargin: EdgeInsets.only(top: 8.0, bottom: 12.0),
          titleCentered: true,
          formatButtonVisible: false,
          formatButtonShowsNext: false,
          titleTextStyle: TextStyle(
              color: AppColors.textColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.0
          ),
          leftChevronVisible: false,
          rightChevronVisible: false,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: _daysOfWeekTextStyle,
            weekendStyle: _daysOfWeekTextStyle
        ),
        daysOfWeekHeight: 36.0,
        calendarStyle: CalendarStyle(
          defaultTextStyle: _dayTextStyle(color: Colors.black87),
          weekendTextStyle: _dayTextStyle(color: Colors.black87),
          outsideTextStyle: _dayTextStyle(color: Colors.black38),
          markersMaxCount: 1,
        ),
        onDaySelected: (date, events) {
          viewModel.updateSelectedDate(date);
        },
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, date, _) {
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
          todayBuilder: (context, date, _) {
            return Container(
              alignment: Alignment.center,
              child: Text(
                '${date.day}',
                style: _dayTextStyle(color: Colors.pinkAccent),
              ),
            );
          },
          markerBuilder: (context, date, events) {
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
            return Container(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: markers
                )
            );
          },
        ),
      )
    );
  }

  TextStyle _daysOfWeekTextStyle = TextStyle(
      color: AppColors.textColor,
      fontSize: 16.0,
      fontWeight: FontWeight.w600
  );

  TextStyle _dayTextStyle({required Color color}) {
    return TextStyle(color: color, fontSize: 17.0);
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