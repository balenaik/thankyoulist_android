import 'package:flutter/material.dart';
import 'package:thankyoulist/models/user_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';

class ConfirmDeleteAccountViewModel with ChangeNotifier {
  UserModel? _authUser;
  String _emailInput = '';

  UserModel? get authUser => _authUser;
  bool get isDeleteButtonEnabled => _emailInput.isNotEmpty && _isValidEmail(_emailInput);

  final AuthRepository authRepository;

  ConfirmDeleteAccountViewModel(this.authRepository) {
  }

  void updateEmail(String value) {
    _emailInput = value;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,64}$')
        .hasMatch(email);
  }
}
