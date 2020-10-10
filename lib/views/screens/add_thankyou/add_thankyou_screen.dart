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
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: FlatButton(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                          'Date',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                          )
                      )
                  ),
              Expanded(
                  child: Text(
                      '2020/11/21',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black54
                      ),
                      textAlign: TextAlign.right
                  )
              )
            ]),
          ),
          color: Colors.white,
          highlightColor: Colors.transparent,
          splashColor: Theme.of(context).primaryColorLight,
          shape: _outlineBorder(Theme.of(context).unselectedWidgetColor),
          onPressed: () {
            FocusManager.instance.primaryFocus.unfocus();
            _selectDate(context);
          },
        )
    );
  }

  OutlineInputBorder _outlineBorder(Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: color, width: 2.0)
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
    );
  }
}
