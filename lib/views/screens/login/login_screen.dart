import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thankyoulist/gen/assets.gen.dart';
import 'package:thankyoulist/status.dart';
import 'package:thankyoulist/viewmodels/login_view_model.dart';
import 'package:thankyoulist/views/common/default_dialog.dart';

import 'package:thankyoulist/views/screens/main/main_screen.dart';
import 'package:thankyoulist/app_colors.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>.value(
        value: LoginViewModel(),
        child: LoginContent()
    );
  }
}

class LoginContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: AppColors.backgroundYellow,
            child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(image: Assets.icLoginScreen, height: 250.0),
                    FacebookSignInButton(),
                    SizedBox(height: 10),
                    GoogleSignInButton()
                  ],
                )
            ),
          ),
          ThankYouLoginStatusHandler()
        ]
      )
    );
  }
}

class FacebookSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginViewModel viewModel = Provider.of<LoginViewModel>(context, listen: false);
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () => viewModel.facebookSignInButtonDidTap(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: SizedBox(
        width: 230,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: Assets.icFacebook, height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Continue with Facebook',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginViewModel viewModel = Provider.of<LoginViewModel>(context, listen: false);
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () => viewModel.googleSignInButtonDidTap(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: SizedBox(
        width: 230,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: Assets.icGoogle, height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ThankYouLoginStatusHandler extends StatelessWidget {
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
    return Selector<LoginViewModel, Status>(
      selector: (context, viewModel) => viewModel.status,
      builder: (context, status, child) {
        switch (status) {
          case ThankYouLoginStatus.loginSuccess:
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                MainScreen(
                  items: [
                    BottomAppBarItem(icon: Icons.list, title: 'List'),
                    BottomAppBarItem(icon: Icons.calendar_today, title: 'calendar'),
                  ],
                  centerItemTitle: 'Add Thank You',
                ),
            ));
            break;
          case ThankYouLoginStatus.loginFailed:
            _showErrorDialog(context, 'Error', 'Could not log in');
            break;
        }
        return Container();
      },
    );
  }
}