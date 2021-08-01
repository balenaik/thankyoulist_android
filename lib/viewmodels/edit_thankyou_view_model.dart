import 'package:flutter/material.dart';
import 'package:thankyoulist/models/thankyou_model.dart';
import 'package:thankyoulist/models/thankyou_update_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';
import 'package:thankyoulist/repositories/thankyou_repiository.dart';
import 'package:thankyoulist/status.dart';

class EditThankYouStatus extends Status {
  EditThankYouStatus(String value) : super(value);

  static const thankYouNotFound = Status('THANKYOU_NOT_FOUND');
  static const editThankYouEditing = Status('EDIT_THANKYOU_EDITING');
  static const editThankYouSuccess = Status('EDIT_THANKYOU_SUCCESS');
  static const editThankYouFailed = Status('EDIT_THANKYOU_FAILED');
  static const deleteThankYouDeleting = Status('DELETE_THANKYOU_DELETING');
  static const deleteThankYouSuccess = Status('DELETE_THANKYOU_SUCCESS');
  static const deleteThankYouFailed = Status('DELETE_THANKYOU_FAILED');
}

class EditThankYouViewModel with ChangeNotifier {
  String? _inputValue;
  DateTime? _selectedDate;
  Status _status = Status.none;
  ThankYouModel? _editingThankYou;

  String? get inputValue => _inputValue;
  DateTime? get selectedDate => _selectedDate;
  Status get status => _status;
  ThankYouModel? get editingThankYou => _editingThankYou;

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
    final editingId = _editingThankYou?.id;
    final inputValue = _inputValue;
    final selectedDate = _selectedDate;
    if (editingId == null || inputValue == null || selectedDate == null) {
      return;
    }

    _status = EditThankYouStatus.editThankYouEditing;
    notifyListeners();
    final userId = await authRepository.getUserId();
    try {
      final thankYouUpdate = ThankYouUpdateModel.from(
          id: editingId,
          value: inputValue,
          date: selectedDate,
          userId: userId
      );
      await thankYouRepository.updateThankYou(userId, thankYouUpdate);
      _status = EditThankYouStatus.editThankYouSuccess;
    } catch (_) {
      _status = EditThankYouStatus.editThankYouFailed;
    }
    notifyListeners();
  }

  Future<void> deleteThankYou() async {
    _status = EditThankYouStatus.deleteThankYouDeleting;
    notifyListeners();
    final userId = await authRepository.getUserId();
    try {
      await thankYouRepository.deleteThankYou(userId, editingThankYouId);
      _status = EditThankYouStatus.deleteThankYouSuccess;
    } catch (_) {
      _status = EditThankYouStatus.deleteThankYouFailed;
    }
    notifyListeners();
  }

  void _loadEditingThankYou() async {
    final userId = await authRepository.getUserId();
    try {
      final editingThankYou = await thankYouRepository.fetchThankYou(userId, editingThankYouId);
      _editingThankYou = editingThankYou;
      _inputValue = editingThankYou.value;
      _selectedDate = _utcDateTime(editingThankYou.date);
    } catch (exception) {
      _status = EditThankYouStatus.thankYouNotFound;
    }
    notifyListeners();
  }

  DateTime _utcDateTime(DateTime datetime) {
    return DateTime.utc(datetime.year, datetime.month, datetime.day);
  }
}