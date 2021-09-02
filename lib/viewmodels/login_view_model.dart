import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thankyoulist/status.dart';

// Note: Name with prefix "ThankYou" because it conflicted with flutter_facebook_auth status without it
class ThankYouLoginStatus extends Status {
  ThankYouLoginStatus(String value) : super(value);

  static const loggingIn = Status('LOGGING_IN');
  static const loginSuccess = Status('LOGIN_SUCCESS');
  static const loginFailed = Status('LOGIN_FAILED');
}

class LoginViewModel with ChangeNotifier {
  Status _status = Status.none;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Status get status => _status;

  void facebookSignInButtonDidTap() {
    _signInWithFacebook();
  }

  void googleSignInButtonDidTap() {
    _signInWithGoogle();
  }

  void _signInWithFacebook() async {
    _status = ThankYouLoginStatus.loggingIn;
    notifyListeners();
    final LoginResult result = await FacebookAuth.instance.login();

    switch (result.status) {
      case LoginStatus.success:
        final token = result.accessToken?.token;
        if (token == null) {
          final reason = 'Login error - Token was null';
          _handleLoginFailed(null, null, reason);
          return;
        }
        OAuthCredential credential = FacebookAuthProvider.credential(token);
        try {
          await _auth.signInWithCredential(credential);
        } catch (exception, stackTrace) {
          final reason = 'Login error - Firebase login error: $exception';
          _handleLoginFailed(exception, stackTrace, reason);
          return;
        }
        _status = ThankYouLoginStatus.loginSuccess;
        notifyListeners();
        return;

      case LoginStatus.operationInProgress:
      case LoginStatus.failed:
      case LoginStatus.cancelled:
        final reason = 'Login error - ${result.status}';
        _handleLoginFailed(null, null, reason);
        return;
    }
  }

  void _signInWithGoogle() async {
    _status = ThankYouLoginStatus.loggingIn;
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
      _status = ThankYouLoginStatus.loginSuccess;
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
    _status = ThankYouLoginStatus.loginFailed;
    notifyListeners();
    await FirebaseCrashlytics.instance.recordError(exception, stackTrace, reason: reason);
  }
}