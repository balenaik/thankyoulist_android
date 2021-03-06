import 'package:flutter/material.dart';
import 'package:thankyoulist/views/screens/thankyoulist/thankyoulist_screen.dart';
import 'package:thankyoulist/views/screens/calendar/calendar_screen.dart';
import 'package:thankyoulist/views/screens/add_thankyou/add_thankyou_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainScreen extends StatefulWidget {
  MainScreen({
    required this.items,
    required this.centerItemTitle,
  }) {
    assert(this.items.length == 2 || this.items.length == 4);
  }
  final List<BottomAppBarItem> items;
  final String centerItemTitle;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _bottomNavigationBarColor = Colors.pink;
  final _selectedItemColor = Colors.white;
  final _unselectedItemColor = Colors.white30;
  final _height = 60.0;
  final _iconSize = 24.0;
  int _selectedIndex = 0;
  final List<Widget> _children = [
    ThankYouListScreen(),
    CalendarScreen()
  ];

  _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(
        widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });

    items.insert(
        items.length >> 1, _buildMiddleTabItem());

    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _children,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: _bottomNavigationBarColor,
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddThankYouScreen(),
                    fullscreenDialog: true
                ),
            );
          },
          tooltip: 'Add Thank You',
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items,
          ),
          color: _bottomNavigationBarColor,
        )
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: _height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: _iconSize),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required BottomAppBarItem item,
    required int index,
    required ValueChanged<int> onPressed,
  }) {
    Color color = _selectedIndex == index ? _selectedItemColor : _unselectedItemColor;
    return Expanded(
      child: SizedBox(
        height: _height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.icon, color: color, size: _iconSize),
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

class BottomAppBarItem {
  BottomAppBarItem({required this.icon, required this.title});
  IconData icon;
  String title;
}