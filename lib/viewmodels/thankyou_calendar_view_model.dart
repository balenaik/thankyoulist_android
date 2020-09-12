import 'package:flutter/material.dart';
import 'package:thankyoulist/models/thankyou_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/model_change_type.dart';
import 'package:thankyoulist/repositories/thankyoulist_repository.dart';

class ThankYouCalendarViewModel with ChangeNotifier {
  // TODO: Is String date better as mapping key than UTC DateTime?
  /// [DateTime(UTC): ThankYouModel] map
  Map<DateTime,  List<ThankYouModel>> _thankYouEvents = {};
  DateTime _selectedDate;

  Map<DateTime,  List<ThankYouModel>> get thankYouEvents => _thankYouEvents;
  DateTime get selectedDate => _selectedDate;

  final ThankYouListRepository thankYouListRepository;
  final AuthRepository authRepository;

  ThankYouCalendarViewModel(this.thankYouListRepository, this.authRepository){
    _selectedDate = _utcDateTime(DateTime.now());
    _addThankYousListener();
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
            _thankYouEvents[_utcDateTime(change.thankYou.date)] ??= List<ThankYouModel>();
            _thankYouEvents[_utcDateTime(change.thankYou.date)].add(change.thankYou);
            break;
          case ModelChangeType.modified:
            _thankYouEvents[_utcDateTime(change.thankYou.date)].removeWhere((thankYou) => thankYou.id == change.thankYou.id);
            _thankYouEvents[_utcDateTime(change.thankYou.date)].add(change.thankYou);
            break;
          case ModelChangeType.removed:
            _thankYouEvents[_utcDateTime(change.thankYou.date)].removeWhere((thankYou) => thankYou.id == change.thankYou.id);
            break;
        }
      });
      notifyListeners();
    });
  }
  
  DateTime _utcDateTime(DateTime datetime) {
    return DateTime.utc(datetime.year, datetime.month, datetime.day);
  }
}