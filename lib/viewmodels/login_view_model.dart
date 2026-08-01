import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thankyoulist/status.dart';

class LoginStatus extends Status {
  LoginStatus(String value) : super(value);

  static const loggingIn = Status('LOGGING_IN');
  static const loginSuccess = Status('LOGIN_SUCCESS');
  static const loginFailed = Status('LOGIN_FAILED');
}

class LoginViewModel with ChangeNotifier {
  Status _status = Status.none;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Status get status => _status;

  void googleSignInButtonDidTap() {
    _signInWithGoogle();
  }

  void _signInWithGoogle() async {
    _status = LoginStatus.loggingIn;
    notifyListeners();
    final _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleCurrentUser = _googleSignIn.currentUser;
    try {
      if (googleCurrentUser == null) googleCurrentUser = await _googleSignIn.signInSilently();
      if (googleCurrentUser == null) googleCurrentUser = await _googleSignIn.signIn();
      if (googleCurrentUser == null) {
        final reason = 'Login error - Could not sign in with Google';
        _handleLoginFailed(null, null, reason);
        return;
      }
      GoogleSignInAuthentication googleAuth = await googleCurrentUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      _status = LoginStatus.loginSuccess;
      notifyListeners();
      return;
    } catch (exception, stackTrace) {
      final reason = 'Login error - Firebase login error: $exception';
      _handleLoginFailed(exception, stackTrace, reason);
      return;
    }
  }

  void _handleLoginFailed(Object? exception, StackTrace? stackTrace, String? reason) async {
    print(reason);
    _status = LoginStatus.loginFailed;
    notifyListeners();
    await FirebaseCrashlytics.instance.recordError(exception, stackTrace, reason: reason);
  }
}