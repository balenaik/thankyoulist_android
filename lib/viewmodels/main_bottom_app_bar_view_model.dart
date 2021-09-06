import 'package:flutter/foundation.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/supports/firebase_initializer.dart';

class MainBottomAppBarViewModel with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  final AuthRepository authRepository;

  MainBottomAppBarViewModel(this.authRepository) {
    _setupFirebaseUserId();
  }

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void _setupFirebaseUserId() async {
    final userId = await authRepository.getUserId();
    FirebaseInitializer.setupUserId(userId);
  }
}