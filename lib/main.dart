import 'package:flutter/material.dart';

void main() => runApp(ThankYouListApp());

class ThankYouListApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thank You List',
      home: BottomNavigationBarWidget(),
//      home: MyHomePage(title: 'title'),
    );
  }
}

class BottomNavigationBarWidget extends StatefulWidget {
  @override
  _BottomNavigationBarWidgetState createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  final _bottomNavigationBarColor = Colors.pink;
  List<Widget> _dynamicPageList;
  int _index = 0;

  @override
  void initState() {
    _dynamicPageList = List();
    _dynamicPageList..add(DynamicPage('1'))..add(DynamicPage('2'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _dynamicPageList[_index],
      floatingActionButton: FloatingActionButton(
        backgroundColor: _bottomNavigationBarColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder:(BuildContext context){
                return DynamicPage('Add Thank You');
              }
          ));
        },
        tooltip: 'Add Thank You',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          color: _bottomNavigationBarColor,
          shape: CircularNotchedRectangle(),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.home),
                    color: Colors.white,
                    onPressed: (){
                      setState(() {
                        _index = 0;
                      });
                    }
                ),
                IconButton(
                    icon: Icon(Icons.dns),
                    color: Colors.white,
                    onPressed: (){
                      setState(() {
                        _index = 1;
                      });
                    }
                ),
                IconButton(
                    icon: Icon(Icons.mail),
                    color: Colors.white,
                    onPressed: (){
                      setState(() {
                        _index = 2;
                      });
                    }
                ),
              ]
          )
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