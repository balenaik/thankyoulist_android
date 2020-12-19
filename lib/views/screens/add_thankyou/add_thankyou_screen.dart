import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:thankyoulist/repositories/thankyou_repiository.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/viewmodels/add_thankyou_view_model.dart';
import 'package:thankyoulist/status.dart';
import 'package:thankyoulist/views/common/default_dialog.dart';

class AddThankYouScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddThankYouViewModel>.value(
        value: AddThankYouViewModel(
          Provider.of<ThankYouRepositoryImpl>(context, listen: false),
          Provider.of<AuthRepositoryImpl>(context, listen: false),
        ),
        child: AddThankYouContent()
    );
  }
}

class AddThankYouContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AddThankYouViewModel viewModel = Provider.of<AddThankYouViewModel>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Thank You'),
          actions: <Widget>[
            FlatButton(
              child: Text("Add", style: TextStyle(fontSize: 17)),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
              onPressed: () => viewModel.createThankYou(),
            ),
          ],
        ),
        backgroundColor: Colors.grey[200],
        body: Stack(
          children: <Widget>[
            ListView(
                children: <Widget>[
                  AddThankYouTextField(),
                  AddThankYouDatePicker()
                ]
            ),
            AddThankYouStatusHandler()
          ],
        )
    );
  }
}

class AddThankYouTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AddThankYouViewModel viewModel = Provider.of<AddThankYouViewModel>(context, listen: false);
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
    AddThankYouViewModel viewModel = Provider.of<AddThankYouViewModel>(context, listen: false);
    return Selector<AddThankYouViewModel, DateTime>(
        selector: (context, viewModel) => viewModel.selectedDate,
        builder: (context, selectedDate, child) {
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
                                DateFormat.yMd().format(selectedDate),
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
                      initialDate: selectedDate,
                      firstDate: DateTime(2010),
                      lastDate: DateTime(2030)
                  );
                  if (pickedDate != null) {
                    viewModel.updateSelectedDate(pickedDate);
                  }},
              ));
        });
  }

  OutlineInputBorder _outlineBorder(Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: color, width: 2.0)
    );
  }
}

class AddThankYouStatusHandler extends StatelessWidget {
  Widget _showErrorDialog(BuildContext context, String title, String message) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialog<DefaultDialog>(
          context: context,
          builder: (context) => DefaultDialog(
            title,
            message,
            onPositiveButtonPressed: () {},
          ));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Selector<AddThankYouViewModel, Status>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        switch (status) {
          case AddThankYouStatus.addThankYouAdding:
            return Container(
                decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.3)),
                child: Center(
                  child: CircularProgressIndicator(),
                )
            );
          case AddThankYouStatus.addThankYouSuccess:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
            break;
          case AddThankYouStatus.addThankYouFailed:
            _showErrorDialog(context, 'Error', 'Could not add Thank You');
        }
        return Container();
      },
    );
  }
}