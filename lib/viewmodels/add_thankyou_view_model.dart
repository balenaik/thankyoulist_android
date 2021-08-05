import 'package:flutter/material.dart';
import 'package:thankyoulist/models/thankyou_create_model.dart';
import 'package:thankyoulist/repositories/app_data_repository.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/thankyou_repiository.dart';
import 'package:thankyoulist/status.dart';

class AddThankYouStatus extends Status {
  AddThankYouStatus(String value) : super(value);

  static const addThankYouAdding = Status('ADD_THANKYOU_ADDING');
  static const addThankYouSuccess = Status('ADD_THANKYOU_SUCCESS');
  static const addThankYouFailed = Status('ADD_THANKYOU_FAILED');
}

class AddThankYouViewModel with ChangeNotifier {
  late String _inputValue;
  late DateTime _selectedDate;
  Status _status = Status.none;

  DateTime get selectedDate => _selectedDate;
  Status get status => _status;
  bool get isDoneButtonEnabled => _inputValue.isNotEmpty;

  final ThankYouRepository thankYouRepository;
  final AuthRepository authRepository;
  final AppDataRepository appDataRepository;

  AddThankYouViewModel(this.thankYouRepository, this.authRepository, this.appDataRepository) {
    _inputValue = "";
    _selectedDate = appDataRepository.loadCalendarSelectedDate() ?? _utcDateTime(DateTime.now());
  }

  void updateInputValue(String value) {
    _inputValue = value;
    notifyListeners();
  }

  void updateSelectedDate(DateTime selectedDate) {
    _selectedDate = selectedDate;
    notifyListeners();
  }

  Future<void> createThankYou() async {
    _status = AddThankYouStatus.addThankYouAdding;
    notifyListeners();
    final userId = await authRepository.getUserId();
    try {
      final thankYouCreate = ThankYouCreateModel.from(
        value: _inputValue,
        date: _selectedDate,
        userId: userId
      );
      await thankYouRepository.createThankYou(userId, thankYouCreate);
      _status = AddThankYouStatus.addThankYouSuccess;
    } catch (_) {
      // Need to wait a bit otherwise status won't be notified to the widget
      // (I guess it's due the timing of changing status is too fast)
      await Future.delayed(Duration(milliseconds: 100));
      _status = AddThankYouStatus.addThankYouFailed;
    }
    notifyListeners();
  }

  DateTime _utcDateTime(DateTime datetime) {
    return DateTime.utc(datetime.year, datetime.month, datetime.day);
  }
}