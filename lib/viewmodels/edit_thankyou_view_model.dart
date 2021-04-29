import 'package:flutter/material.dart';
import 'package:thankyoulist/models/thankyou_model.dart';
import 'package:thankyoulist/models/thankyou_update_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/thankyou_repiository.dart';
import 'package:thankyoulist/status.dart';

class EditThankYouStatus extends Status {
  EditThankYouStatus(String value) : super(value);

  static const editThankYouEditing = Status('EDIT_THANKYOU_EDITING');
  static const editThankYouSuccess = Status('EDIT_THANKYOU_SUCCESS');
  static const editThankYouFailed = Status('EDIT_THANKYOU_FAILED');
}

class EditThankYouViewModel with ChangeNotifier {
  String _inputValue;
  DateTime _selectedDate;
  Status _status = Status.none;
  ThankYouModel _editingThankYou;

  String get inputValue => _inputValue;
  DateTime get selectedDate => _selectedDate;
  Status get status => _status;
  ThankYouModel get editingThankYou => _editingThankYou;

  final ThankYouRepository thankYouRepository;
  final AuthRepository authRepository;

  final String editingThankYouId;

  EditThankYouViewModel(this.thankYouRepository, this.authRepository, this.editingThankYouId) {
    _loadEditingThankYou();
  }

  void updateInputValue(String value) {
    _inputValue = value;
  }

  void updateSelectedDate(DateTime selectedDate) {
    _selectedDate = selectedDate;
    notifyListeners();
  }

  Future<void> editThankYou() async {
    _status = EditThankYouStatus.editThankYouEditing;
    notifyListeners();
    final userId = await authRepository.getUserId();
    final thankYouUpdate = ThankYouUpdateModel.from(
        id: _editingThankYou.id,
        value: _inputValue,
        date: _selectedDate,
        userId: userId
    );
    try {
      await thankYouRepository.updateThankYou(userId, thankYouUpdate);
      _status = EditThankYouStatus.editThankYouSuccess;
    } on Exception {
      _status = EditThankYouStatus.editThankYouFailed;
    }
    notifyListeners();
  }

  void _loadEditingThankYou() async {
    final userId = await authRepository.getUserId();
    _editingThankYou = await thankYouRepository.fetchThankYou(userId, editingThankYouId);
    _inputValue = _editingThankYou.value;
    _selectedDate = _utcDateTime(_editingThankYou.date);
    notifyListeners();
  }

  DateTime _utcDateTime(DateTime datetime) {
    return DateTime.utc(datetime.year, datetime.month, datetime.day);
  }
}