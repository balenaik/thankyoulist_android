import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thankyoulist/gen/assets.gen.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/status.dart';
import 'package:thankyoulist/viewmodels/my_page_view_model.dart';
import 'package:thankyoulist/views/common/default_app_bar.dart';
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
        appBar: DefaultAppBar(title: 'Account'),
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
    final photoUrl = viewModel.authUser?.photoUrl;
    final ImageProvider<Object> avatarImage;
    if (photoUrl != null) {
      avatarImage = NetworkImage(photoUrl);
    } else {
      avatarImage = Assets.icons.accountCircle20;
    }
    final displayName = viewModel.authUser?.displayName ?? "";
    final email = viewModel.authUser?.email ?? "";
    return Container(
      margin: EdgeInsets.fromLTRB(36.0, 28.0, 36.0, 20.0),
      child: Row(
          children: <Widget>[
            CircleAvatar(
                radius: 28,
                backgroundImage: avatarImage
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                child: Column(
                  children: [
                    Text(
                        displayName,
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.left
                    ),
                    Text(
                        viewModel.authUser != null ? email : "",
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
        child: TextButton(
            child: Text(
                'Log out',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.red,
                )
            ),
            style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                primary: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
            ),
            onPressed: () => _showLogoutDialog(context)
        )
    );
  }

  void _showLogoutDialog(BuildContext context) {
    MyPageViewModel viewModel = Provider.of<MyPageViewModel>(context, listen: false);
    showDialog<DefaultDialog>(
        context: context,
        builder: (context) {
          return DefaultDialog(
            'Log out',
            'Are you sure you want to logout?',
            positiveButtonTitle: 'Log out',
            onPositiveButtonPressed: () => viewModel.logout(),
            onNegativeButtonPressed: () {},
          );
        }
    );
  }
}

class MyPageStatusHandler extends StatelessWidget {
  void _showErrorDialog(BuildContext context, String title, String message) {
    MyPageViewModel viewModel = Provider.of<MyPageViewModel>(context, listen: false);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
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
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);
            });
            break;
          case MyPageStatus.logOutFailed:
            WidgetsBinding.instance?.addPostFrameCallback((_) {
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