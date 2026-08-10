import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/viewmodels/confirm_delete_account_view_model.dart';

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
        ],
      ),
    );
  }
}
