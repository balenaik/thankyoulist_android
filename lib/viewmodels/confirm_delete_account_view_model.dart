import 'package:flutter/material.dart';
import 'package:thankyoulist/models/user_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/status.dart';

class ConfirmDeleteAccountStatus extends Status {
  ConfirmDeleteAccountStatus(String value) : super(value);

  static const loadAuthInfoFailed = Status('LOAD_AUTH_INFO_FAILED');
  static const emailMismatch = Status('EMAIL_MISMATCH');
  static const deleting = Status('DELETING');
  static const deleteSuccess = Status('DELETE_SUCCESS');
  static const deleteFailed = Status('DELETE_FAILED');
}

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
      _status = ConfirmDeleteAccountStatus.emailMismatch;
      notifyListeners();
      return;
    }

    _status = ConfirmDeleteAccountStatus.deleting;
    notifyListeners();
    try {
      await authRepository.deleteAccount();
      authRepository.setUserId(null);
      _status = ConfirmDeleteAccountStatus.deleteSuccess;
    } catch (_) {
      _status = ConfirmDeleteAccountStatus.deleteFailed;
    }
    notifyListeners();
  }

  void clearStatus() {
    _status = Status.none;
    notifyListeners();
  }

  Future<void> _loadAuthInfo() async {
    try {
      _authUser = await authRepository.getUser();
    } catch (_) {
      _status = ConfirmDeleteAccountStatus.loadAuthInfoFailed;
    }
    notifyListeners();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,64}$')
        .hasMatch(email);
  }
}
