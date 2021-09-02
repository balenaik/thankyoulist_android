import 'package:flutter/material.dart';
import 'package:thankyoulist/models/user_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/status.dart';
import 'package:thankyoulist/supports/firebase_initializer.dart';

class MyPageStatus extends Status {
  MyPageStatus(String value) : super(value);

  static const loggingOut = Status('LOGGING_OUT');
  static const logOutSuccess = Status('LOG_OUT_SUCCESS');
  static const logOutFailed = Status('LOG_OUT_FAILED');
}

class MyPageViewModel with ChangeNotifier {
  UserModel? _authUser;
  Status _status = Status.none;

  UserModel? get authUser => _authUser;
  Status get status => _status;

  final AuthRepository authRepository;

  MyPageViewModel(this.authRepository) {
    _loadAuthInfo();
  }

  Future<void> logout() async {
    _status = MyPageStatus.loggingOut;
    notifyListeners();
    try {
      await authRepository.logout();
      FirebaseInitializer.setupUserId(null);
      _status = MyPageStatus.logOutSuccess;
    } catch(error) {
      _status = MyPageStatus.logOutFailed;
    }
    notifyListeners();
  }

  void logoutErrorOkButtonDidTap() {
    _status = Status.none;
    notifyListeners();
  }

  Future<void> _loadAuthInfo() async {
    final user = await authRepository.getUser();
    _authUser = user;
    notifyListeners();
  }
}