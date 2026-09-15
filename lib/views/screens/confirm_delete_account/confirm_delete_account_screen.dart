import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thankyoulist/app_colors.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/status.dart';
import 'package:thankyoulist/viewmodels/confirm_delete_account_view_model.dart';
import 'package:thankyoulist/views/common/default_dialog.dart';

const _buttonHeight = 48.0;

class ConfirmDeleteAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConfirmDeleteAccountViewModel>(
      create: (_) => ConfirmDeleteAccountViewModel(
        Provider.of<AuthRepositoryImpl>(context, listen: false),
      ),
      child: _ConfirmDeleteAccountContent(),
    );
  }
}

class _ConfirmDeleteAccountContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar.large(
                title: Text('Confirm your email', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 16.0,
                    children: [
                      _Description(),
                      _EmailField(),
                      _DeleteAccountButton(),
                      _CancelButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _ConfirmDeleteAccountStatusHandler(),
        ],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Complete deletion of your account and your data by entering the email address associated with your account.',
      style: TextStyle(
        fontSize: 16,
        color: AppColors.textColor,
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ConfirmDeleteAccountViewModel>(context, listen: true);

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    );
    return TextField(
        decoration: InputDecoration(
          hintText: viewModel.registeredEmail,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade400
          ),
          filled: true,
          fillColor: Colors.white,
          border: border,
          enabledBorder: border,
          focusedBorder: border,
        ),
        style: const TextStyle(fontSize: 16),
        keyboardType: TextInputType.emailAddress,
        onChanged: viewModel.updateEmail,
    );
  }
}

class _DeleteAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ConfirmDeleteAccountViewModel>(context, listen: true);
    final redAccent200 = Colors.redAccent[200] ?? Colors.redAccent;
    const disabledOpacity = 0.38;

    return SizedBox(
      height: _buttonHeight,
      child: TextButton(
        onPressed: viewModel.isDeleteButtonEnabled
          ? viewModel.deleteAccount
          : null,
        style: TextButton.styleFrom(
          backgroundColor: redAccent200,
          disabledBackgroundColor: redAccent200.withValues(alpha: disabledOpacity),
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white.withValues(alpha: disabledOpacity),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text(
          'Delete Account',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _buttonHeight,
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          'Cancel',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
      ),
    );
  }
}

class _ConfirmDeleteAccountStatusHandler extends StatelessWidget {
  void _showDialog(
    BuildContext context, {
    bool barrierDismissible = true,
    required String title,
    required String message,
    required VoidCallback onPositiveButtonPressed,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog<DefaultDialog>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (_) => DefaultDialog(
          title,
          message,
          onPositiveButtonPressed: onPositiveButtonPressed,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ConfirmDeleteAccountViewModel, Status>(
      selector: (_, viewModel) => viewModel.status,
      builder: (context, status, _) {
        final viewModel = Provider.of<ConfirmDeleteAccountViewModel>(context,
            listen: false);

        switch (status) {
          case ConfirmDeleteAccountStatus.loadAuthInfoFailed:
            _showDialog(
              context,
              title: 'Unable to Delete Your Account',
              message: "Please ask the developer from 'Give us Feedback' menu.",
              onPositiveButtonPressed: () => Navigator.pop(context),
            );
          case ConfirmDeleteAccountStatus.emailMismatch:
            _showDialog(
              context,
              title: "Email address doesn't match your account",
              message: 'Please enter your registered email address: ${viewModel.registeredEmail}',
              onPositiveButtonPressed: () => viewModel.clearStatus(),
            );
          case ConfirmDeleteAccountStatus.deleteSuccess:
            _showDialog(
              context,
              barrierDismissible: false,
              title: 'Your account has been deleted',
              message: '',
              onPositiveButtonPressed: () {
                Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
              },
            );
          case ConfirmDeleteAccountStatus.deleteFailed:
            _showDialog(
              context,
              title: 'Unable to Delete Your Account',
              message: 'Please try again later.',
              onPositiveButtonPressed: () => viewModel.clearStatus(),
            );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
