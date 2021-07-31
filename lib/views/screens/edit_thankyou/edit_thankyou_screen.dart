import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:thankyoulist/app_colors.dart';
import 'package:thankyoulist/repositories/thankyou_repiository.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/viewmodels/edit_thankyou_view_model.dart';
import 'package:thankyoulist/status.dart';
import 'package:thankyoulist/views/common/default_dialog.dart';
import 'package:thankyoulist/views/themes/light_theme.dart';

class EditThankYouScreen extends StatelessWidget {
  final String editingThankYouId;

  EditThankYouScreen(this.editingThankYouId);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditThankYouViewModel>.value(
        value: EditThankYouViewModel(
          Provider.of<ThankYouRepositoryImpl>(context, listen: false),
          Provider.of<AuthRepositoryImpl>(context, listen: false),
          editingThankYouId
        ),
        child: EditThankYouContent()
    );
  }
}

class EditThankYouContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EditThankYouViewModel viewModel = Provider.of<EditThankYouViewModel>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Thank You',
            style: TextStyle(
                color: primaryColor[900],
                fontWeight: FontWeight.bold
            ),
          ),
          centerTitle: true,
          shape: Border(bottom: BorderSide(color: AppColors.appBarBottomBorderColor)),
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: primaryColor[900]),
          actions: <Widget>[
            FlatButton(
              child: Text("Edit", style: TextStyle(fontSize: 17)),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
              onPressed: () => viewModel.editThankYou(),
            ),
          ],
        ),
        backgroundColor: Colors.grey[200],
        body: Stack(
          children: <Widget>[
            ListView(
                children: <Widget>[
                  EditThankYouTextField(),
                  EditThankYouDatePicker(),
                  EditThankYouDeleteButton()
                ]
            ),
            EditThankYouStatusHandler()
          ],
        )
    );
  }
}

class EditThankYouTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EditThankYouViewModel viewModel = Provider.of<EditThankYouViewModel>(context, listen: false);
    return Selector<EditThankYouViewModel, String?>(
        selector: (context, viewModel) => viewModel.inputValue,
        builder: (context, inputValue, child) {
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
                controller: TextEditingController(text: inputValue),
              )
          );
        });
  }

  OutlineInputBorder _outlineBorder(Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: color, width: 2.0)
    );
  }
}

class EditThankYouDatePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EditThankYouViewModel viewModel = Provider.of<EditThankYouViewModel>(context, listen: false);
    return Selector<EditThankYouViewModel, DateTime?>(
        selector: (context, viewModel) => viewModel.selectedDate,
        builder: (context, selectedDate, child) {
          String dateString = selectedDate != null ? DateFormat.yMd().format(selectedDate) : "";
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
                                dateString,
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
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (selectedDate == null) {
                    return;
                  }
                  // TODO: OK and cancel colors are too light for the current primary swatch colors
                  final DateTime? pickedDate = await showDatePicker(
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

class EditThankYouDeleteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: FlatButton(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            child: Text(
                'Delete',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.red
                )
            )
          ),
          color: Colors.white,
          highlightColor: Colors.transparent,
          splashColor: Theme.of(context).primaryColorLight,
          shape: _outlineBorder(Theme.of(context).unselectedWidgetColor),
          onPressed: () async {
            _showDeleteDialog(context);
          },
        ));
  }

  void _showDeleteDialog(BuildContext context) {
    EditThankYouViewModel viewModel = Provider.of<EditThankYouViewModel>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
                title: Text('Delete Thank You'),
                content: Container(
                  child: Text('Are you sure you want to delete this thank you?'),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () => viewModel.deleteThankYou(),
                  ),
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                )
              );
        }
    );
  }

  OutlineInputBorder _outlineBorder(Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: color, width: 2.0)
    );
  }
}

class EditThankYouStatusHandler extends StatelessWidget {
  Widget? _showErrorDialog(BuildContext context, String title, String message) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
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
    return Selector<EditThankYouViewModel, Status>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        switch (status) {
          case EditThankYouStatus.thankYouNotFound:
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
            break;
          case EditThankYouStatus.editThankYouEditing:
          case EditThankYouStatus.deleteThankYouDeleting:
            return Container(
                decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.3)),
                child: Center(
                  child: CircularProgressIndicator(),
                )
            );
          case EditThankYouStatus.editThankYouSuccess:
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
            break;
          case EditThankYouStatus.editThankYouFailed:
            _showErrorDialog(context, 'Error', 'Could not edit Thank You');
            break;
          case EditThankYouStatus.deleteThankYouSuccess:
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
            break;
          case EditThankYouStatus.deleteThankYouFailed:
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              // Close the delete confirm dialog first
              Navigator.of(context).pop();
            });
            _showErrorDialog(context, 'Error', 'Could not delete Thank You');
            break;
        }
        return Container();
      },
    );
  }
}