import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:collection/collection.dart';
import 'package:thankyoulist/models/thankyou_list_view_ui_model.dart';
import 'package:thankyoulist/models/thankyou_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/model_change_type.dart';
import 'package:thankyoulist/repositories/thankyou_repiository.dart';
import 'package:thankyoulist/repositories/thankyoulist_repository.dart';
import 'package:thankyoulist/status.dart';

class ThankYouListStatus extends Status {
  ThankYouListStatus(String value) : super(value);

  static const deleteThankYouDeleting = Status('DELETE_THANKYOU_DELETING');
  static const deleteThankYouSuccess = Status('DELETE_THANKYOU_SUCCESS');
  static const deleteThankYouFailed = Status('DELETE_THANKYOU_FAILED');
}

class ThankYouListViewModel with ChangeNotifier {
  SplayTreeMap<DateTime, List<ThankYouModel>> _thankYouListMap = SplayTreeMap<DateTime, List<ThankYouModel>>();
  SplayTreeMap<SectionMonthYearModel, Set<DateTime>> _datesByMonthsMap = SplayTreeMap<SectionMonthYearModel, Set<DateTime>>();
  Status _status = Status.none;

  List<ThankYouListViewUiModel> get thankYouListWithDate => _getThankYouListWithDate();
  Status get status => _status;

  final ThankYouListRepository thankYouListRepository;
  final ThankYouRepository thankYouRepository;
  final AuthRepository authRepository;

  ThankYouListViewModel(this.thankYouListRepository, this.thankYouRepository, this.authRepository){
    _addThankYouListListener();
  }

  Future<void> deleteThankYou(String thankYouId) async {
    _status = ThankYouListStatus.deleteThankYouDeleting;
    notifyListeners();
    final userId = await authRepository.getUserId();
    try {
      await thankYouRepository.deleteThankYou(userId, thankYouId);
      _status = ThankYouListStatus.deleteThankYouSuccess;
    } catch (_) {
      // Need to wait a bit otherwise status won't be notified to the widget
      await Future.delayed(Duration(milliseconds: 100));
      _status = ThankYouListStatus.deleteThankYouFailed;
    }
    notifyListeners();
  }

  void _addThankYouListListener() async {
    final userId = await authRepository.getUserId();
    Stream<List<ThankYouListChange>> stream = thankYouListRepository.addThankYouListener(userId);
    stream.listen((event) {
      event.forEach((change) {
        switch (change.type) {
          case ModelChangeType.added:
            _addThankYouToMap(change);
            break;
          case ModelChangeType.modified:
            _deleteThankYouFromMap(change);
            _addThankYouToMap(change);
            break;
          case ModelChangeType.removed:
            _deleteThankYouFromMap(change);
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

  void _addThankYouToMap(ThankYouListChange change) {
    DateTime dateTime = _utcDateTime(change.thankYou.date);
    SectionMonthYearModel monthYear = SectionMonthYearModel(month: dateTime.month, year: dateTime.year);
    _thankYouListMap[dateTime] ??= [];
    _thankYouListMap[dateTime]?.add(change.thankYou);
    _datesByMonthsMap[monthYear] ??= Set<DateTime>();
    _datesByMonthsMap[monthYear]?.add(dateTime);
  }

  void _deleteThankYouFromMap(ThankYouListChange change) {
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