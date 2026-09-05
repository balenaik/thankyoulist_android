import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thankyoulist/app_colors.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/viewmodels/confirm_delete_account_view_model.dart';

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
        onPressed: null,
        child: const Text(),
      ),
    );
  }
}
