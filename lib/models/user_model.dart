import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String photoUrl;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.photoUrl
  });

  factory UserModel.from({required User firebaseUser}) {
    // Use providerData.last to get photoURL with Google Auth and email with facebook Auth
    return UserModel(
        id: firebaseUser.uid,
        displayName: firebaseUser.displayName ?? "",
        email: firebaseUser.providerData.last.email ?? "",
        photoUrl: firebaseUser.providerData.last.photoURL ?? ""
    );
  }
}