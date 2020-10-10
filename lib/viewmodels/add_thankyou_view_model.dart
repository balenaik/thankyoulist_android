import 'package:flutter/material.dart';

class AddThankYouViewModel with ChangeNotifier {
  DateTime _selectedDate;

  DateTime get selectedDate => _selectedDate;

  AddThankYouViewModel() {
    _selectedDate = _utcDateTime(DateTime.now());
  }

  void updateSelectedDate(DateTime selectedDate) {
    _selectedDate = selectedDate;
    notifyListeners();
  }

  DateTime _utcDateTime(DateTime datetime) {
    return DateTime.utc(datetime.year, datetime.month, datetime.day);
  }
}