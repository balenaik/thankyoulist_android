import 'package:flutter/material.dart';
import 'package:thankyoulist/models/user_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/status.dart';

class MyPageStatus extends Status {
  MyPageStatus(String value) : super(value);

  static const loggingOut = Status('LOGGING_OUT');
  static const logOutSuccess = Status('LOG_OUT_SUCCESS');
  static const logOutFailed = Status('LOG_OUT_FAILED');
}

class MyPageViewModel with ChangeNotifier {
  UserModel _authUser;

  UserModel get authUser => _authUser;

  final AuthRepository authRepository;

  MyPageViewModel(this.authRepository) {
    _loadAuthInfo();
  }

  Future<void> _loadAuthInfo() async {
    final user = await authRepository.getUser();
    _authUser = user;
    notifyListeners();
  }
}