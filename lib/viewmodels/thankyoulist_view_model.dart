import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:thankyoulist/models/thankyou_list_view_ui_model.dart';
import 'package:thankyoulist/models/thankyou_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/model_change_type.dart';
import 'package:thankyoulist/repositories/thankyoulist_repository.dart';

class ThankYouListViewModel with ChangeNotifier {
  SplayTreeMap<DateTime, List<ThankYouModel>> _thankYouListMap = SplayTreeMap<DateTime, List<ThankYouModel>>();

  List<ThankYouListViewUiModel> get thankYouListWithDate => _getThankYouListWithDate();

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
            _thankYouListMap[_utcDateTime(change.thankYou.date)] ??= List<ThankYouModel>();
            _thankYouListMap[_utcDateTime(change.thankYou.date)].add(change.thankYou);
            break;
          case ModelChangeType.modified:
            _thankYouListMap[_utcDateTime(change.thankYou.date)].removeWhere((thankYou) => thankYou.id == change.thankYou.id);
            _thankYouListMap[_utcDateTime(change.thankYou.date)].add(change.thankYou);
            break;
          case ModelChangeType.removed:
            _thankYouListMap[_utcDateTime(change.thankYou.date)].removeWhere((thankYou) => thankYou.id == change.thankYou.id);
            break;
        }
      });
      notifyListeners();
    });
  }

  List<ThankYouListViewUiModel> _getThankYouListWithDate() {
    List<ThankYouListViewUiModel> result = List<ThankYouListViewUiModel>();
    _thankYouListMap.forEach((dateTime, thankYous) {
      thankYous.forEach((thankYou) {
        result.add(ThankYouListViewUiModel(thankYou: thankYou));
      });
      result.add(ThankYouListViewUiModel(sectionDate: dateTime));
    });
    // Needs to be sorted in desc
    return result.reversed.toList();
  }

  DateTime _utcDateTime(DateTime datetime) {
    return DateTime.utc(datetime.year, datetime.month, datetime.day);
  }
}