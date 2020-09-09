import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thankyoulist/models/thankyou_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/model_change_type.dart';
import 'package:thankyoulist/repositories/thankyoulist_repository.dart';

class ThankYouListViewModel with ChangeNotifier {
  List<ThankYouModel> _thankYouList = List<ThankYouModel>();
  List<ThankYouModel> get thankYouList => _thankYouList;

  final ThankYouListRepository thankYouListRepository;
  final AuthRepository authRepository;

  ThankYouListViewModel(this.thankYouListRepository, this.authRepository){
    _addThankYouListListener();
  }

  void _addThankYouListListener() async {
    final userId = await authRepository.getUserId();
    Stream<List<ThankYouListChange>> stream = thankYouListRepository.addThankYouListener(userId);
    stream.listen((event) {
      event.forEach((change) {
        switch (change.type) {
          case ModelChangeType.added:
            _thankYouList.add(change.thankYou);
            break;
          case ModelChangeType.modified:
            _thankYouList.removeWhere((thankYou) => thankYou.id == change.thankYou.id);
            _thankYouList.add(change.thankYou);
            break;
          case ModelChangeType.removed:
            _thankYouList.removeWhere((thankYou) => thankYou.id == change.thankYou.id);
            break;
        }
      });
      notifyListeners();
    });
  }
}