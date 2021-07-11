import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thankyoulist/viewmodels/main_bottom_app_bar_view_model.dart';
import 'package:thankyoulist/views/screens/thankyoulist/thankyoulist_screen.dart';
import 'package:thankyoulist/views/screens/calendar/calendar_screen.dart';
import 'package:thankyoulist/views/screens/add_thankyou/add_thankyou_screen.dart';
import 'package:thankyoulist/extensions/list_extension.dart';
import 'package:thankyoulist/views/themes/light_theme.dart';

const double _bottomAppBarHeight = 60.0;
const double _bottomAppBarIconSize = 24.0;

class MainBottomAppBarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainBottomAppBarViewModel>.value(
        value: MainBottomAppBarViewModel(),
        child: MainBottomAppBarContent()
    );
  }
}

class MainBottomAppBarContent extends StatelessWidget {
  List<BottomAppBarItem> barItems = [
    BottomAppBarItem(icon: Icons.list, title: 'List', widget: ThankYouListScreen()),
    BottomAppBarItem(icon: Icons.calendar_today, title: 'calendar', widget: CalendarScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    MainBottomAppBarViewModel viewModel = Provider.of<MainBottomAppBarViewModel>(context, listen: true);

    return Scaffold(
        body: IndexedStack(
          index: viewModel.selectedIndex,
          children: barItems.map((item) => item.widget).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => _showAddThankYou(context),
          tooltip: 'Add Thank You',
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _createBottomAppBarItems(),
          ),
          color: primaryColor[50],
        )
    );
  }

  void _showAddThankYou(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddThankYouScreen(),
          fullscreenDialog: true
      ),
    );
  }

  List<BottomAppBarWidget> _createBottomAppBarItems() {
    List<BottomAppBarWidget> appBarItems = barItems.mapIndex<BottomAppBarWidget>((item, index) => ItemBottomAppBarWidget(item, index)).toList();
    if (barItems.length.isEven) {
      // Only supports even length of barItems
      final middleEmptyItemIndex = barItems.length ~/ 2;
      appBarItems.insert(middleEmptyItemIndex, MiddleBottomAppBarWidget());
    }
    return appBarItems;
  }
}

class ItemBottomAppBarWidget extends StatelessWidget implements BottomAppBarWidget {
  ItemBottomAppBarWidget(this.item, this.index);

  final BottomAppBarItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    MainBottomAppBarViewModel viewModel = Provider.of<MainBottomAppBarViewModel>(context, listen: false);
    Color color = viewModel.selectedIndex == index
        ? primaryColor[900] ?? primaryColor : Theme.of(context).hintColor;
    return Expanded(
      child: SizedBox(
        height: _bottomAppBarHeight,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => viewModel.updateIndex(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.icon, color: color, size: _bottomAppBarIconSize),
                Text(
                  item.title,
                  style: TextStyle(color: color),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MiddleBottomAppBarWidget extends StatelessWidget implements BottomAppBarWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: _bottomAppBarHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: _bottomAppBarIconSize),
          ],
        ),
      ),
    );
  }
}

abstract class BottomAppBarWidget extends Widget {}

class BottomAppBarItem {
  BottomAppBarItem({
    required this.icon,
    required this.title,
    required this.widget
  });
  IconData icon;
  String title;
  StatelessWidget widget;
}