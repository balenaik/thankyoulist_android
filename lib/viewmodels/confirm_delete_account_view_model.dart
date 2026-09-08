import 'package:flutter/material.dart';
import 'package:thankyoulist/models/user_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/status.dart';

class ConfirmDeleteAccountViewModel with ChangeNotifier {
  UserModel? _authUser;
  Status _status = Status.none;
  String _emailInput = '';

  String get registeredEmail => _authUser?.email ?? '';
  Status get status => _status;
  bool get isDeleteButtonEnabled => _emailInput.isNotEmpty && _isValidEmail(_emailInput);
  bool get _emailInputMatchesRegisteredEmail =>
      _emailInput.toLowerCase() == registeredEmail.toLowerCase();

  final AuthRepository authRepository;

  ConfirmDeleteAccountViewModel(this.authRepository) {
    _loadAuthInfo();
  }

  void updateEmail(String value) {
    _emailInput = value;
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    if (!isDeleteButtonEnabled) return;
    if (!_emailInputMatchesRegisteredEmail) {
      return;
    }

    await authRepository.deleteAccount();
  }

  Future<void> _loadAuthInfo() async {
    _authUser = await authRepository.getUser();
    notifyListeners();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,64}$')
        .hasMatch(email);
  }
}
