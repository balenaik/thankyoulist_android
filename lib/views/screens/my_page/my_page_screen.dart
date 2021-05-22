import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/status.dart';
import 'package:thankyoulist/viewmodels/my_page_view_model.dart';
import 'package:thankyoulist/views/common/default_dialog.dart';

class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyPageViewModel>.value(
        value: MyPageViewModel(
          Provider.of<AuthRepositoryImpl>(context, listen: false),
        ),
        child: MyPageScreenContent()
    );
  }
}

class MyPageScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Account')
        ),
        backgroundColor: Colors.grey[200],
        body: Stack(
          children: <Widget>[
            ListView(
                children: <Widget>[
                  UserProfileWidget(),
                  LogoutButton()
                ]
            ),
            MyPageStatusHandler()
          ],
        )
    );
  }
}

class UserProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyPageViewModel viewModel = Provider.of<MyPageViewModel>(context, listen: true);
    return Container(
      margin: EdgeInsets.fromLTRB(36.0, 28.0, 36.0, 20.0),
      child: Row(
          children: <Widget>[
            CircleAvatar(
                radius: 28,
                backgroundImage: viewModel.authUser != null
                    ? NetworkImage(viewModel.authUser.photoUrl)
                    : AssetImage("assets/icons/account_circle_20.png")
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                child: Column(
                  children: [
                    Text(
                        viewModel.authUser != null ? viewModel.authUser.displayName : "",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.left
                    ),
                    Text(
                        viewModel.authUser != null ? viewModel.authUser.email : "",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black54
                        ),
                        textAlign: TextAlign.left
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                )
            )
          ]),
    );
  }
}

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: FlatButton(
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
              child: Text(
                  'Log out',
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
            _showLogoutDialog(context);
          },
        )
    );
  }

  void _showLogoutDialog(BuildContext context) {
    MyPageViewModel viewModel = Provider.of<MyPageViewModel>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Log out'),
              content: Container(
                child: Text('Are you sure you want to logout?'),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text("Log out"),
                  onPressed: () => viewModel.logout(),
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

class MyPageStatusHandler extends StatelessWidget {
  void _showErrorDialog(BuildContext context, String title, String message) {
    MyPageViewModel viewModel = Provider.of<MyPageViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showDialog<DefaultDialog>(
          context: context,
          builder: (context) => DefaultDialog(
            title,
            message,
            onPositiveButtonPressed: () => viewModel.logoutErrorOkButtonDidTap(),
          ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MyPageViewModel, Status>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        switch (status) {
          case MyPageStatus.loggingOut:
            return Container(
                decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.3)),
                child: Center(
                  child: CircularProgressIndicator(),
                )
            );
          case MyPageStatus.logOutSuccess:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);
            });
            break;
          case MyPageStatus.logOutFailed:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Close the logout confirm dialog first
              Navigator.of(context).pop();
            });
            _showErrorDialog(context, 'Error', 'Could not log out');
        }
        return Container();
      },
    );
  }
}