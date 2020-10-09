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
              AddThankYouTextField()
            ]
        )
    );
  }
}

class AddThankYouTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: 24.0
        ),
        child: TextField(
          style: TextStyle(
              fontSize: 17
          ),
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