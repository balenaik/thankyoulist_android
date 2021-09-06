import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thankyoulist/gen/assets.gen.dart';
import 'package:thankyoulist/status.dart';
import 'package:thankyoulist/viewmodels/login_view_model.dart';
import 'package:thankyoulist/views/common/default_dialog.dart';

import 'package:thankyoulist/app_colors.dart';
import 'package:thankyoulist/views/screens/main_bottom_app_bar/main_bottom_app_bar_screen.dart';
import 'package:thankyoulist/views/themes/light_theme.dart';

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
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(image: Assets.images.loginImage),
                    SizedBox(height: 12),
                    _titleText(context),
                    SizedBox(height: 8),
                    _descriptionText(context),
                    SizedBox(height: 20),
                    _buttonRow(_signInButton(
                        iconImage: Assets.icFacebook,
                        title: 'Continue with Facebook',
                        tapAction: () => viewModel.facebookSignInButtonDidTap())),
                    SizedBox(height: 12),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: <Widget>[
            Image(image: iconImage, height: 20.0),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
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

  Text _titleText(BuildContext context) {
    return Text(
        'Thank You List',
        style: TextStyle(
            color: primaryColor[900],
            fontSize: 36,
            fontWeight: FontWeight.bold
        )
    );
  }

  Text _descriptionText(BuildContext context) {
    return Text(
      'Take a simple diary \n& be happier',
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 18,
        ),
        textAlign: TextAlign.center
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
          case ThankYouLoginStatus.loggingIn:
            return Container(
                decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.3)),
                child: Center(
                  child: CircularProgressIndicator(),
                )
            );
          case ThankYouLoginStatus.loginSuccess:
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                MainBottomAppBarScreen(),
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