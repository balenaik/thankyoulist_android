import 'package:flutter/material.dart';
import 'package:thankyoulist/thankyoulist_screen.dart';
import 'package:thankyoulist/calendar_screen.dart';
import 'package:thankyoulist/login_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainScreen extends StatefulWidget {
  MainScreen({
    this.items,
    this.centerItemTitle,
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
    ThankYouListScreen(Colors.white70),
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
        body: _children[_selectedIndex],
        floatingActionButton: FloatingActionButton(
          backgroundColor: _bottomNavigationBarColor,
          onPressed: () {
//            Navigator.of(context).push(MaterialPageRoute(
//                builder:(BuildContext context){
//                  return DynamicPage(widget.centerItemTitle);
//                }
//            ));
            signOutGoogle();
//            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginScreen();}), ModalRoute.withName('/'));
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
    BottomAppBarItem item,
    int index,
    ValueChanged<int> onPressed,
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

class DynamicPage extends StatefulWidget {
  String _title;
  DynamicPage(this._title);
  @override
  _DynamicPageState createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget._title)),
        body: Center(child:Text(widget._title))
    );
  }
}

class BottomAppBarItem {
  BottomAppBarItem({this.icon, this.title});
  IconData icon;
  String title;
}

void signOutGoogle() async{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  await _googleSignIn.signOut();
  await FirebaseAuth.instance.signOut();

  print("User Sign Out");
}