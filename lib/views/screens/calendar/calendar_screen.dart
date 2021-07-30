import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:thankyoulist/app_colors.dart';
import 'package:thankyoulist/gen/assets.gen.dart';
import 'package:thankyoulist/gen/fonts.gen.dart';

import 'package:thankyoulist/models/thankyou_model.dart';
import 'package:thankyoulist/repositories/app_data_repository.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/thankyoulist_repository.dart';
import 'package:thankyoulist/viewmodels/thankyou_calendar_view_model.dart';
import 'package:thankyoulist/views/common/child_size_notifier.dart';
import 'package:thankyoulist/views/common/thankyou_item.dart';
import 'package:thankyoulist/extensions/list_extension.dart';
import 'package:thankyoulist/views/common/remove_glowingover_scrollindicator_behavior.dart';
import 'package:thankyoulist/views/screens/edit_thankyou/edit_thankyou_screen.dart';
import 'package:thankyoulist/views/screens/my_page/my_page_screen.dart';
import 'package:thankyoulist/views/themes/light_theme.dart';

const int _markerMaxCount = 4;
const double _markerSize = 8.0;
const double _circleMarkerSize = 6.0;

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThankYouCalendarViewModel>.value(
        value: ThankYouCalendarViewModel(
          Provider.of<ThankYouListRepositoryImpl>(context, listen: false),
          Provider.of<AuthRepositoryImpl>(context, listen: false),
          Provider.of<AppDataRepositoryImpl>(context, listen: false)
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
    GlobalKey _calendarKey = GlobalKey();
    return LayoutBuilder(builder: (context, constraints) {
      return ChildSizeNotifier(
        sizingChildKey: _calendarKey,
        child: CalendarScreenBaseCalendar(_calendarKey),
        builder: (context, calendarSize, child) {
          double minHeight = (constraints.maxHeight - calendarSize.height) - 12;
          if (minHeight < 0) {
            minHeight = 0;
          }
          return SlidingUpPanel(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0)
              ),
              boxShadow: <BoxShadow>[], // Delete shadow
              maxHeight: constraints.maxHeight,
              minHeight: minHeight,
              color: Colors.white,
              panelBuilder: (scrollController) {
                return SlidingUpListView(scrollController);
              },
              body: child
          );
         },
      );
    });
  }
}

class SlidingUpListView extends StatelessWidget {
  final ScrollController scrollController;
  SlidingUpListView(this.scrollController);

  @override
  Widget build(BuildContext context) {
    ThankYouCalendarViewModel viewModel = Provider.of<ThankYouCalendarViewModel>(context, listen: true);
    List<ThankYouModel>? selectedThankYous = viewModel.thankYouEvents[viewModel.selectedDate];
    return Column(
      children: <Widget>[
        _dateView(viewModel.selectedDate),
        Expanded(
            child: ScrollConfiguration(
                behavior: RemoveGlowingOverScrollIndicatorBehavior(),
                child: ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: selectedThankYous?.length ?? 0,
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
                        return Container();
                      }
                    })
            )
        ),
      ],
    );
  }

  Widget _dateView(DateTime date) {
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
                    fontSize: 17,
                    fontWeight: FontWeight.w600
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
  GlobalKey _calendarKey;
  CalendarScreenBaseCalendar(this._calendarKey);

  @override
  Widget build(BuildContext context) {
    ThankYouCalendarViewModel viewModel = Provider.of<ThankYouCalendarViewModel>(context, listen: true);
    return Column(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: TableCalendar(
                key: _calendarKey,
                focusedDay: viewModel.focusedDate,
                firstDay: DateTime(2015),
                lastDay: DateTime(2050),
                eventLoader: viewModel.getThankYouEvents,
                sixWeekMonthsEnforced: true,
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
                onDaySelected: (selectedDate, focusedDate) {
                  viewModel.updateSelectedAndFocusedDate(selectedDate: selectedDate, focusedDate: focusedDate);
                },
                calendarBuilders: CalendarBuilders(
                    defaultBuilder: _dayBuilder(selectedDate: viewModel.selectedDate, color: AppColors.textColor),
                    todayBuilder: _dayBuilder(selectedDate: viewModel.selectedDate, color: primaryColor[900] ?? Theme.of(context).primaryColor),
                    outsideBuilder: _dayBuilder(selectedDate: viewModel.selectedDate, color: Colors.black26),
                    markerBuilder: _markerBuilder()
                ),
              )
          ),
          Expanded(child: Container())
        ]
    );
  }

  TextStyle _daysOfWeekTextStyle = TextStyle(
      color: AppColors.textColor,
      fontSize: 16.0,
      fontWeight: FontWeight.w600
  );

  TextStyle _dayTextStyle({required Color color}) {
    return TextStyle(color: color, fontSize: 17.0, fontWeight: FontWeight.w600);
  }

  FocusedDayBuilder _dayBuilder({required DateTime selectedDate, required Color color}) {
    return (BuildContext context, DateTime date, DateTime focusedDay) {
      if (selectedDate == date) {
        return _selectedDayCell(context: context, date: date, color: color);
      }
      return _normalDayCell(date: date, color: color);
    };
  }

  Widget _normalDayCell({required DateTime date, required Color color}) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '${date.day}',
        style: _dayTextStyle(color: color),
      )
    );
  }

  Widget _selectedDayCell({required BuildContext context, required DateTime date, required Color color}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primaryColor[200]?.withOpacity(0.6) ?? Theme.of(context).primaryColorLight
      ),
      margin: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Text(
        '${date.day}',
        style: _dayTextStyle(color: color),
      )
    );
  }

  MarkerBuilder _markerBuilder() {
    return (BuildContext context, DateTime day, List events) {
      List<Widget> markers = [];
      events.asMap().forEach((index, event) {
        if (index > _markerMaxCount - 1) {
          return;
        }
        if (index == _markerMaxCount - 1) {
          markers.removeLast();
          markers.add(_moreMarker(context));
          return;
        }
        if (index != 0) {
          markers.add(_markerSpacer());
        }
        markers.add(_circleMarker(context));
      });
      return SizedBox(
          height: 12,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: markers
          )
      );
    };
  }

  Widget _circleMarker(BuildContext context) {
    return SizedBox(
      width: _markerSize,
      height: _markerSize,
      child: Icon(
          Icons.circle,
          color: _markerColor(context),
          size: _circleMarkerSize
      ),
    );
  }

  Widget _moreMarker(BuildContext context) {
    return SizedBox(
        width: _markerSize,
        height: _markerSize,
        child: Assets.icons.plus30.image(color: _markerColor(context))
    );
  }

  Widget _markerSpacer() {
    return SizedBox(
      width: 1.0,
      child: Container()
    );
  }

  Color _markerColor(BuildContext context) {
    return primaryColor[900] ?? Theme.of(context).primaryColor;
  }
}