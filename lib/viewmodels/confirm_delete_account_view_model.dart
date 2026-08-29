import 'package:flutter/material.dart';
import 'package:thankyoulist/models/user_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';

class ConfirmDeleteAccountViewModel with ChangeNotifier {
  UserModel? _authUser;
  String _emailInput = '';

  String get registeredEmail => _authUser?.email ?? '';
  bool get isDeleteButtonEnabled => _emailInput.isNotEmpty && _isValidEmail(_emailInput);

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
