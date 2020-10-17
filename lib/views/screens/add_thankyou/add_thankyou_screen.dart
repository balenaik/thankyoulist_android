import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:thankyoulist/viewmodels/add_thankyou_view_model.dart';

class AddThankYouScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AddThankYouViewModel viewModel = Provider.of<AddThankYouViewModel>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Thank You'),
          actions: <Widget>[
            FlatButton(
              child: Text("Add", style: TextStyle(fontSize: 17)),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
              onPressed: () async {
                final bool succeed = await viewModel.createThankYou();
                if (succeed == true) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
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
    AddThankYouViewModel viewModel = Provider.of<AddThankYouViewModel>(context, listen: true);
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
          onChanged: (String value) => viewModel.updateInputValue(value),
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
    AddThankYouViewModel viewModel = Provider.of<AddThankYouViewModel>(context, listen: true);
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
                      DateFormat.yMd().format(viewModel.selectedDate),
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
          onPressed: () async {
            FocusManager.instance.primaryFocus.unfocus();
            // TODO: OK and cancel colors are too light for the current primary swatch colors
            final DateTime pickedDate = await showDatePicker(
              context: context,
              initialDate: viewModel.selectedDate,
              firstDate: DateTime(2010),
              lastDate: DateTime(2030)
            );
            if (pickedDate != null) {
              viewModel.updateSelectedDate(pickedDate);
            }
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
}
