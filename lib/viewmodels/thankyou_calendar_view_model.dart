import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:thankyoulist/models/thankyou_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/model_change_type.dart';
import 'package:thankyoulist/repositories/thankyoulist_repository.dart';

class ThankYouCalendarViewModel with ChangeNotifier {
  // TODO: Is String date better than UTC DateTime as mapping key?
  /// [DateTime(UTC): ThankYouModel] map
  Map<DateTime, List<ThankYouModel>> _thankYouEvents = {};
  DateTime _selectedDate;

  Map<DateTime, List<ThankYouModel>> get thankYouEvents => _thankYouEvents;
  DateTime get selectedDate => _selectedDate;

  final ThankYouListRepository thankYouListRepository;
  final AuthRepository authRepository;

  ThankYouCalendarViewModel(this.thankYouListRepository, this.authRepository){
    _selectedDate = _utcDateTime(DateTime.now());
    _addThankYousListener();
  }

  List<ThankYouModel> getThankYouEvents(DateTime day) {
    return _thankYouEvents[day] ?? [];
  }

  void updateSelectedDate(DateTime selectedDate) {
    _selectedDate = selectedDate;
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
    _thankYouEvents[dateTime] ??= List<ThankYouModel>();
    _thankYouEvents[dateTime].add(change.thankYou);
  }

  void _deleteThankYou(ThankYouListChange change) {
    ThankYouModel oldThankYou;
    // Extract old thankyou by changed id
    for (DateTime key in _thankYouEvents.keys) {
      oldThankYou = _thankYouEvents[key].firstWhere((thankYou) =>
      thankYou.id == change.thankYou.id,
          orElse: () => null
      );
      if (oldThankYou != null) {
        break;
      }
    }
    if (oldThankYou == null) {
      // Do nothing if old thankyou is not found
      return;
    }
    DateTime dateTime = _utcDateTime(oldThankYou.date);
    _thankYouEvents[dateTime].removeWhere((thankYou) => thankYou.id == change.thankYou.id);
  }
  
  DateTime _utcDateTime(DateTime datetime) {
    return DateTime.utc(datetime.year, datetime.month, datetime.day);
  }
}