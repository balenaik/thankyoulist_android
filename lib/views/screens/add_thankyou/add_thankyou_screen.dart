import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:thankyoulist/app_colors.dart';
import 'package:thankyoulist/repositories/app_data_repository.dart';
import 'package:thankyoulist/repositories/thankyou_repiository.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/viewmodels/add_thankyou_view_model.dart';
import 'package:thankyoulist/status.dart';
import 'package:thankyoulist/views/common/default_app_bar.dart';
import 'package:thankyoulist/views/common/default_dialog.dart';
import 'package:thankyoulist/views/themes/light_theme.dart';

const double _rowMinHeight = 48;
const EdgeInsets _rowMargin = EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0);
const double _rowComponentBorderRadius = 16;

class AddThankYouScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddThankYouViewModel>.value(
        value: AddThankYouViewModel(
          Provider.of<ThankYouRepositoryImpl>(context, listen: false),
          Provider.of<AuthRepositoryImpl>(context, listen: false),
          Provider.of<AppDataRepositoryImpl>(context, listen: false)
        ),
        child: AddThankYouContent()
    );
  }
}

class AddThankYouContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(
          title: 'Add Thank You',
          leading: AddThankYouCloseButton(),
        ),
        backgroundColor: AppColors.settingScreenBackgroundColor,
        body: Stack(
          children: <Widget>[
            ListView(
                children: <Widget>[
                  SizedBox(height: 12),
                  AddThankYouTextField(),
                  AddThankYouDatePicker(),
                  AddThankYouDoneButton()
                ]
            ),
            AddThankYouStatusHandler()
          ],
        )
    );
  }
}

class AddThankYouCloseButton extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return Selector<AddThankYouViewModel, bool>(
       selector: (context, viewModel) => viewModel.showsDiscardAlertDialog,
       builder: (context, showsDiscardAlertDialog, child) {
         return CloseButton(
           onPressed: showsDiscardAlertDialog ? () => _showDiscardAlertDialog(context) : null,
         );
       });
 }

 Widget? _showDiscardAlertDialog(BuildContext context) {
   WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
     showDialog<DefaultDialog>(
         context: context,
         builder: (context) => DefaultDialog(
           'Discard Thank You?',
           'Are you sure you want to discard your thank you?',
           positiveButtonTitle: 'Discard',
           negativeButtonTitle: 'Keep Editing',
           onPositiveButtonPressed: () {
             Navigator.maybePop(context);
           },
           onNegativeButtonPressed: () {},
         ));
   });
 }
}

class AddThankYouTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AddThankYouViewModel viewModel = Provider.of<AddThankYouViewModel>(context, listen: false);
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
        )
    );
  }

  final OutlineInputBorder _outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(_rowComponentBorderRadius),
      borderSide: BorderSide(style: BorderStyle.none)
  );
}

class AddThankYouDatePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AddThankYouViewModel viewModel = Provider.of<AddThankYouViewModel>(context, listen: false);
    return Selector<AddThankYouViewModel, DateTime>(
        selector: (context, viewModel) => viewModel.selectedDate,
        builder: (context, selectedDate, child) {
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
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_rowComponentBorderRadius))
                ),
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
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

class AddThankYouDoneButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AddThankYouViewModel viewModel = Provider.of<AddThankYouViewModel>(context, listen: false);
    return Selector<AddThankYouViewModel, bool>(
      selector: (context, viewModel) => viewModel.isDoneButtonEnabled,
      builder: (context, isDoneButtonEnabled, child) {
        final backgroundOpacity = isDoneButtonEnabled ? 1.0 : 0.38;
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
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(backgroundOpacity),
                    primary: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_rowComponentBorderRadius))
                ),
                onPressed: isDoneButtonEnabled ? () => viewModel.createThankYou() : null
            )
        );
      }
    );
  }
}

class AddThankYouStatusHandler extends StatelessWidget {
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
            WidgetsBinding.instance?.addPostFrameCallback((_) {
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