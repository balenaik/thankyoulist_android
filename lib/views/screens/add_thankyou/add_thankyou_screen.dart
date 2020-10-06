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
              minLines: 4,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'What are you thankful for?',
                labelStyle: TextStyle(
                  fontFamily: 'Nunito',
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey[300], width: 2.0)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xFFFF8980), width: 2.0)
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