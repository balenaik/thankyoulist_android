import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:thankyoulist/views/screens/main/main_screen.dart';
import 'package:thankyoulist/app_colors.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final FacebookLogin _facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> _handleGoogleSignIn() async {
    GoogleSignInAccount googleCurrentUser = _googleSignIn.currentUser;
    try {
      if (googleCurrentUser == null) googleCurrentUser = await _googleSignIn.signInSilently();
      if (googleCurrentUser == null) googleCurrentUser = await _googleSignIn.signIn();
      if (googleCurrentUser == null) return null;

      GoogleSignInAuthentication googleAuth = await googleCurrentUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Future<FirebaseUser> _handleFacebookSignIn() async {
  //   final FacebookLoginResult result = await _facebookLogin.logIn(['email']);
  //
  //   switch (result.status) {
  //     case FacebookLoginStatus.error:
  //       print("Error");
  //       break;
  //
  //     case FacebookLoginStatus.cancelledByUser:
  //       print("CancelledByUser");
  //       break;
  //
  //     case FacebookLoginStatus.loggedIn:
  //       print("LoggedIn");
  //       /// calling the auth mehtod and getting the logged user
  //       AuthCredential credential= FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);
  //       FirebaseUser firebaseUser = (await _auth.signInWithCredential(credential)).user;
  //       print("signed in " + firebaseUser.displayName);
  //       return firebaseUser;
  //   }
  // }

  void transitionNextPage(User user) {
    if (user == null) return;

    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        MainScreen(
          items: [
            BottomAppBarItem(icon: Icons.list, title: 'List'),
            BottomAppBarItem(icon: Icons.calendar_today, title: 'calendar'),
          ],
          centerItemTitle: 'Add Thank You',
        ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundYellow,
        child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage("assets/ic_login_screen.png"), height: 250.0),
                _facebookSignInButton(),
                SizedBox(height: 10),
                _googleSignInButton()
              ],
            )
        ),
      ),
    );
  }

  Widget _googleSignInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        _handleGoogleSignIn()
            .then((User user) =>
            transitionNextPage(user)
        )
            .catchError((e) => print(e));
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: SizedBox(
        width: 230,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("assets/ic_google.png"), height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _facebookSignInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        // _handleFacebookSignIn()
        //     .then((FirebaseUser user) =>
        //     transitionNextPage(user)
        // )
        //     .catchError((e) => print(e));
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: SizedBox(
        width: 230,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("assets/ic_facebook.png"), height: 35.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Continue with Facebook',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}