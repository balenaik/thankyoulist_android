import 'package:flutter/material.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';

class ConfirmDeleteAccountViewModel with ChangeNotifier {
  final AuthRepository authRepository;

  ConfirmDeleteAccountViewModel(this.authRepository) {
  }
}
