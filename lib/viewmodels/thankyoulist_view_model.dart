import 'package:flutter/material.dart';
import 'package:thankyoulist/models/thankyou_model.dart';
import 'package:thankyoulist/repositories/model_change_type.dart';
import 'package:thankyoulist/repositories/thankyoulist_repository.dart';

class ThankYouListViewModel with ChangeNotifier {
  List<ThankYouModel> _thankYouList = List<ThankYouModel>();
  List<ThankYouModel> get thankYouList => _thankYouList;

  // TODO: Use factory
  final ThankYouListRepository repository = ThankYouListRepositoryImpl();

  ThankYouListViewModel(){
    _addThankYouListListener();
  }

  void _addThankYouListListener({ String userId }) async {
    Stream<List<ThankYouListChange>> stream = repository.addThankYouListener(userId);
    stream.listen((event) {
      event.map((change) {
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
        notifyListeners();
      });
    });
  }
}