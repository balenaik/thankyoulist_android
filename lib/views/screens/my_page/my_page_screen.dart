import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thankyoulist/app_colors.dart';
import 'package:thankyoulist/gen/assets.gen.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/status.dart';
import 'package:thankyoulist/viewmodels/my_page_view_model.dart';
import 'package:thankyoulist/views/common/default_app_bar.dart';
import 'package:thankyoulist/views/common/default_dialog.dart';
import 'package:thankyoulist/views/screens/confirm_delete_account/confirm_delete_account_screen.dart';
import 'package:url_launcher/url_launcher.dart';

const _feedbackToEmail = 'balenaik+thankyoulist-feedback@gmail.com';
const _feedbackSubject = 'Thank You List Feedback';

const _buttonHeight = 50.0;
const _buttonFontSize = 17.0;
const _buttonMargin = EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0);

ButtonStyle _buttonStyle(BuildContext context) {
  return TextButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
  );
}

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
        backgroundColor: AppColors.settingScreenBackgroundColor,
        body: Stack(
          children: <Widget>[
            ListView(
                children: <Widget>[
                  UserProfileWidget(),
                  FeedbackButton(),
                  LogoutButton(),
                  DeleteAccountButton(),
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

class FeedbackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: _buttonHeight,
        margin: _buttonMargin,
        child: TextButton(
            child: Text(
                'Give us Feedback',
                style: TextStyle(
                  fontSize: _buttonFontSize,
                  color: AppColors.textColor,
                )
            ),
            style: _buttonStyle(context),
            onPressed: () => _openMailApp(context)
        )
    );
  }

  Future<void> _openMailApp(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: _feedbackToEmail,
      queryParameters: {'subject': _feedbackSubject},
    );
    bool launched;
    try {
      launched = await launchUrl(uri);
    } catch (_) {
      launched = false;
    }
    if (!launched && context.mounted) {
      _showUnableToSendEmailDialog(context);
    }
  }

  void _showUnableToSendEmailDialog(BuildContext context) {
    showDialog<DefaultDialog>(
        context: context,
        builder: (context) {
          return DefaultDialog(
            'Could Not Send Email',
            'Your device could not send email.\nPlease check your email configuration and try again. Or send email to balenaik@gmail.com',
            onPositiveButtonPressed: () {},
          );
        }
    );
  }
}

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: _buttonHeight,
        margin: _buttonMargin,
        child: TextButton(
            child: Text(
                'Log out',
                style: TextStyle(
                  fontSize: _buttonFontSize,
                  color: AppColors.textColor,
                )
            ),
            style: _buttonStyle(context),
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

class DeleteAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: _buttonHeight,
        margin: _buttonMargin,
        child: TextButton(
            child: Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: _buttonFontSize,
                  color: Colors.redAccent[200],
                )
            ),
            style: _buttonStyle(context),
            onPressed: () => _showDeleteAccountDialog(context)
        )
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog<DefaultDialog>(
        context: context,
        builder: (context) {
          return DefaultDialog(
            'Delete Account',
            'By deleting the account, all data will be permanently deleted and you will no longer access your Thank You List. Are you sure you want to delete your Thank You List account?',
            positiveButtonTitle: 'Next',
            onPositiveButtonPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ConfirmDeleteAccountScreen(),
                fullscreenDialog: true,
              ),
            ),
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
              Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
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