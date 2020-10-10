import 'package:flutter/material.dart';

class AddThankYouScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Thank You'),
        ),
        backgroundColor: Colors.grey[200],
        body: ListView(
            children: <Widget>[
              AddThankYouTextField(),
              AddThankYouDatePicker()
            ]
        )
    );
  }
}

class AddThankYouTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 24.0,
            bottom: 12.0
        ),
        child: TextField(
          style: TextStyle(fontSize: 17),
          minLines: 4,
          maxLines: null,
          decoration: InputDecoration(
              hintText: 'What are you thankful for?',
              enabledBorder: _outlineBorder(Theme.of(context).unselectedWidgetColor),
              focusedBorder: _outlineBorder(Theme.of(context).primaryColor),
              filled: true,
              fillColor: Colors.white
          ),
        )
    );
  }

  OutlineInputBorder _outlineBorder(Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: color, width: 2.0)
    );
  }
}

class AddThankYouDatePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).unselectedWidgetColor,
                spreadRadius: 2.0),
          ],
        ),
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            child: Row(
                children: <Widget>[
                  Expanded(child: Text('Date')),
                  Expanded(child: Text('2020/11/21', textAlign: TextAlign.right))
                ]
            ),
            height: 50
        )
    );
  }
}
