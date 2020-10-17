import 'dart:core';
import 'package:intl/intl.dart';
import 'package:thankyoulist/crypto.dart';

class ThankYouCreateModel {
  final String encryptedValue;
  final DateTime date;
  final DateTime createdDate;

  ThankYouCreateModel({
    this.encryptedValue,
    this.date,
    this.createdDate
  });

  factory ThankYouCreateModel.from({String value, DateTime date, String userId}) {
    return ThankYouCreateModel(
      encryptedValue: Crypto().encryptAESCrypto(value, userId.substring(0, 16)),
      date: date,
      createdDate: DateTime.now()
    );
  }

  Map<String, dynamic> toJson() => {
    'encryptedValue': encryptedValue,
    'date': DateFormat('yyyy/MM/dd').format(date),
    'createTime': createdDate
  };
}