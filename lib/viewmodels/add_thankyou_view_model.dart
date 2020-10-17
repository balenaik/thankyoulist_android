import 'package:flutter/material.dart';
import 'package:thankyoulist/models/thankyou_create_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/thankyou_repiository.dart';

class AddThankYouViewModel with ChangeNotifier {
  String _inputValue;
  DateTime _selectedDate;

  String get inputValue => _inputValue;
  DateTime get selectedDate => _selectedDate;

  final ThankYouRepository thankYouRepository;
  final AuthRepository authRepository;

  AddThankYouViewModel(this.thankYouRepository, this.authRepository) {
    _inputValue = "";
    _selectedDate = _utcDateTime(DateTime.now());
  }

  void updateInputValue(String value) {
    _inputValue = value;
  }

  void updateSelectedDate(DateTime selectedDate) {
    _selectedDate = selectedDate;
    notifyListeners();
  }

  Future<bool> createThankYou() async {
    final userId = await authRepository.getUserId();
    final thankYouCreate = ThankYouCreateModel.from(
      value: _inputValue,
      date: _selectedDate,
      userId: userId
    );
    return thankYouRepository.createThankYou(userId, thankYouCreate);
  }

  DateTime _utcDateTime(DateTime datetime) {
    return DateTime.utc(datetime.year, datetime.month, datetime.day);
  }
}