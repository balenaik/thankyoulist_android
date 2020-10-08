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
          Container(
              margin: EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 24.0
              ),
              child: TextField(
                style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 17
                ),
              minLines: 4,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'What are you thankful for?',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Theme.of(context).unselectedWidgetColor, width: 2.0)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0)
                ),
                filled: true,
                fillColor: Colors.white
              ),
            )
          )
        ]
      )
    );
  }
}