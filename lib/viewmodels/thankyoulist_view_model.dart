import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:thankyoulist/models/thankyou_list_view_ui_model.dart';
import 'package:thankyoulist/models/thankyou_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/model_change_type.dart';
import 'package:thankyoulist/repositories/thankyoulist_repository.dart';

class ThankYouListViewModel with ChangeNotifier {
  SplayTreeMap<DateTime, List<ThankYouModel>> _thankYouListMap = SplayTreeMap<DateTime, List<ThankYouModel>>();
  SplayTreeMap<SectionMonthYearModel, Set<DateTime>> _datesByMonthsMap = SplayTreeMap<SectionMonthYearModel, Set<DateTime>>();

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
            _addThankYou(change);
            break;
          case ModelChangeType.modified:
            _deleteThankYou(change);
            _addThankYou(change);
            break;
          case ModelChangeType.removed:
            _deleteThankYou(change);
            break;
        }
      });
      notifyListeners();
    });
  }

  List<ThankYouListViewUiModel> _getThankYouListWithDate() {
    List<ThankYouListViewUiModel> result = [];
    _datesByMonthsMap.forEach((monthYear, dateTimes) {
      List<DateTime> sortedDates = dateTimes.toList();
      sortedDates.sort();
      sortedDates.forEach((dateTime) {
        _thankYouListMap[dateTime]?.forEach((thankYou) {
          result.add(ThankYouListViewUiModel(thankYou: thankYou));
        });
      });
      result.add(ThankYouListViewUiModel(sectionMonthYear: monthYear));
    });
    // Needs to be sorted in desc
    return result.reversed.toList();
  }

  void _addThankYou(ThankYouListChange change) {
    DateTime dateTime = _utcDateTime(change.thankYou.date);
    SectionMonthYearModel monthYear = SectionMonthYearModel(month: dateTime.month, year: dateTime.year);
    _thankYouListMap[dateTime] ??= [];
    _thankYouListMap[dateTime]?.add(change.thankYou);
    _datesByMonthsMap[monthYear] ??= Set<DateTime>();
    _datesByMonthsMap[monthYear]?.add(dateTime);
  }

  void _deleteThankYou(ThankYouListChange change) {
    ThankYouModel? oldThankYou;
    // Extract old thankyou by changed id
    for (DateTime key in _thankYouListMap.keys) {
      oldThankYou = _thankYouListMap[key]?.firstWhereOrNull((thankYou) => thankYou.id == change.thankYou.id);
      if (oldThankYou != null) {
        break;
      }
    }
    if (oldThankYou == null) {
      // Do nothing if old thankyou is not found
      return;
    }
    DateTime dateTime = _utcDateTime(oldThankYou.date);
    SectionMonthYearModel monthYear = SectionMonthYearModel(month: dateTime.month, year: dateTime.year);
    _thankYouListMap[dateTime]?.removeWhere((thankYou) => thankYou.id == change.thankYou.id);
    if (_thankYouListMap[dateTime]?.isEmpty ?? false) {
      _datesByMonthsMap[monthYear]?.remove(dateTime);
    }
    if (_datesByMonthsMap[monthYear]?.isEmpty ?? false) {
      _datesByMonthsMap.remove(monthYear);
    }
  }

  DateTime _utcDateTime(DateTime datetime) {
    return DateTime.utc(datetime.year, datetime.month, datetime.day);
  }
}