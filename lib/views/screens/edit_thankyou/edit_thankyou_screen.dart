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

const double _rowMinHeight = 48;
const EdgeInsets _rowMargin = EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0);
const double _rowComponentBorderRadius = 16;

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
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Thank You',
            style: TextStyle(
                color: AppColors.textColor,
                fontWeight: FontWeight.bold
            ),
          ),
          centerTitle: true,
          shape: Border(bottom: BorderSide(color: AppColors.appBarBottomBorderColor)),
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: AppColors.textColor),
        ),
        backgroundColor: Colors.grey[200],
        body: Stack(
          children: <Widget>[
            ListView(
                children: <Widget>[
                  SizedBox(height: 12),
                  EditThankYouTextField(),
                  EditThankYouDatePicker(),
                  EditThankYouDoneButton()
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
    return Selector<EditThankYouViewModel, String>(
        selector: (context, viewModel) => viewModel.initialValue,
        builder: (context, initialValue, child) {
          return Container(
              margin: _rowMargin,
              child: TextField(
                style: TextStyle(fontSize: 17),
                minLines: 4,
                maxLines: null,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'What are you thankful for?',
                    enabledBorder: _outlineBorder,
                    focusedBorder: _outlineBorder,
                    filled: true,
                    fillColor: Colors.white
                ),
                onChanged: (String value) => viewModel.updateInputValue(value),
                controller: TextEditingController(text: initialValue),
              )
          );
        });
  }

  final OutlineInputBorder _outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(_rowComponentBorderRadius),
      borderSide: BorderSide(style: BorderStyle.none)
  );
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
              height: _rowMinHeight,
              margin: _rowMargin,
              child: TextButton(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                  child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                                'Date',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textColor
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
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_rowComponentBorderRadius))
                ),
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (selectedDate == null) {
                    return;
                  }
                  final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2010),
                      lastDate: DateTime(2030),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                            data: Theme.of(context).copyWith(
                              textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                      primary: primaryColor[900],
                                      textStyle: TextStyle(fontWeight: FontWeight.w600)
                                  )
                              ),
                            ),
                            child: child ?? Container()
                        );
                      }
                  );
                  if (pickedDate != null) {
                    viewModel.updateSelectedDate(pickedDate);
                  }},
              ));
        });
  }
}

class EditThankYouDoneButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EditThankYouViewModel viewModel = Provider.of<EditThankYouViewModel>(context, listen: false);
    return Container(
        height: _rowMinHeight,
        margin: _rowMargin,
        child: TextButton(
            child: Text(
                'Done',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                )
            ),
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                primary: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_rowComponentBorderRadius))
            ),
            onPressed: () => viewModel.editThankYou()
        )
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
        }
        return Container();
      },
    );
  }
}