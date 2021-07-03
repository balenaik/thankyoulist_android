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
    LoginViewModel viewModel = Provider.of<LoginViewModel>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              color: AppColors.backgroundYellow,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(child: Image(image: Assets.icLoginScreen, height: 250.0)),
                    _buttonRow(_signInButton(
                        iconImage: Assets.icFacebook,
                        title: 'Continue with Facebook',
                        tapAction: () => viewModel.facebookSignInButtonDidTap())),
                    SizedBox(height: 10),
                    _buttonRow(_signInButton(
                        iconImage: Assets.icGoogle,
                        title: 'Continue with Google',
                        tapAction: () => viewModel.googleSignInButtonDidTap()))
                  ],
              )
            ),
          ThankYouLoginStatusHandler()
        ]
      )
    );
  }

  Widget _buttonRow(OutlinedButton button) {
    return Row(
      children: [
        Spacer(flex: 1),
        Expanded(flex: 8, child: button),
        Spacer(flex: 1)
      ],
    );
  }

  OutlinedButton _signInButton({
    required ImageProvider iconImage,
    required String title,
    required VoidCallback tapAction
  }) {
    return OutlinedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          overlayColor: MaterialStateProperty.all<Color>(Colors.grey.withAlpha(20)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))
          ),
          side: MaterialStateProperty.all<BorderSide>(BorderSide(width: 0.5))
      ),
      onPressed: tapAction,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: <Widget>[
            Image(image: iconImage, height: 20.0),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ),
            )
          ],
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