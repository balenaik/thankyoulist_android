import 'package:flutter/material.dart';
import 'package:thankyoulist/models/user_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';

class ConfirmDeleteAccountViewModel with ChangeNotifier {
  UserModel? _authUser;
  String _emailInput = '';

  UserModel? get authUser => _authUser;
  final AuthRepository authRepository;

  ConfirmDeleteAccountViewModel(this.authRepository) {
  }

  void updateEmail(String value) {
    _emailInput = value;
  }
}
