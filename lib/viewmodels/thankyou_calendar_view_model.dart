import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:thankyoulist/models/thankyou_model.dart';
import 'package:thankyoulist/repositories/app_data_repository.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/model_change_type.dart';
import 'package:thankyoulist/repositories/thankyou_repiository.dart';
import 'package:thankyoulist/repositories/thankyoulist_repository.dart';
import 'package:thankyoulist/status.dart';

class ThankYouCalendarStatus extends Status {
  ThankYouCalendarStatus(String value) : super(value);

  static const deleteThankYouDeleting = Status('DELETE_THANKYOU_DELETING');
  static const deleteThankYouSuccess = Status('DELETE_THANKYOU_SUCCESS');
  static const deleteThankYouFailed = Status('DELETE_THANKYOU_FAILED');
}

class ThankYouCalendarViewModel with ChangeNotifier {
  // TODO: Is String date better than UTC DateTime as mapping key?
  /// [DateTime(UTC): ThankYouModel] map
  Map<DateTime, List<ThankYouModel>> _thankYouEvents = {};
  late DateTime _selectedDate;
  late DateTime _focusedDate;
  Status _status = Status.none;

  Map<DateTime, List<ThankYouModel>> get thankYouEvents => _thankYouEvents;
  DateTime get selectedDate => _selectedDate;
  DateTime get focusedDate => _focusedDate;
  Status get status => _status;

  final ThankYouListRepository thankYouListRepository;
  final ThankYouRepository thankYouRepository;
  final AuthRepository authRepository;
  final AppDataRepository appDataRepository;

  ThankYouCalendarViewModel(
      this.thankYouListRepository,
      this.thankYouRepository,
      this.authRepository,
      this.appDataRepository){
    _selectedDate = _utcDateTime(DateTime.now());
    _focusedDate = _utcDateTime(DateTime.now());
    _addThankYousListener();
  }

  List<ThankYouModel> getThankYouEvents(DateTime day) {
    return _thankYouEvents[day] ?? [];
  }

  void updateSelectedAndFocusedDate({required DateTime selectedDate, required DateTime focusedDate}) {
    _selectedDate = selectedDate;
    _focusedDate = focusedDate;
    appDataRepository.writeCalendarSelectedDate(selectedDate);
    notifyListeners();
  }

  Future<void> deleteThankYou(String thankYouId) async {
    _status = ThankYouCalendarStatus.deleteThankYouDeleting;
    notifyListeners();
    final userId = await authRepository.getUserId();
    try {
      await thankYouRepository.deleteThankYou(userId, thankYouId);
      _status = ThankYouCalendarStatus.deleteThankYouSuccess;
    } catch (_) {
      // Need to wait a bit otherwise status won't be notified to the widget
      await Future.delayed(Duration(milliseconds: 100));
      _status = ThankYouCalendarStatus.deleteThankYouFailed;
    }
    notifyListeners();
  }

  void _addThankYousListener() async {
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

  void _addThankYou(ThankYouListChange change) {
    DateTime dateTime = _utcDateTime(change.thankYou.date);
    _thankYouEvents[dateTime] ??= [];
    _thankYouEvents[dateTime]?.add(change.thankYou);
  }

  void _deleteThankYou(ThankYouListChange change) {
    ThankYouModel? oldThankYou;
    // Extract old thankyou by changed id
    for (DateTime key in _thankYouEvents.keys) {
      oldThankYou = _thankYouEvents[key]?.firstWhereOrNull((thankYou) => thankYou.id == change.thankYou.id);
      if (oldThankYou != null) {
        break;
      }
    }
    if (oldThankYou == null) {
      // Do nothing if old thankyou is not found
      return;
    }
    DateTime dateTime = _utcDateTime(oldThankYou.date);
    _thankYouEvents[dateTime]?.removeWhere((thankYou) => thankYou.id == change.thankYou.id);
  }
  
  DateTime _utcDateTime(DateTime datetime) {
    return DateTime.utc(datetime.year, datetime.month, datetime.day);
  }
}