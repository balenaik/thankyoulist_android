import 'dart:core';
import 'package:intl/intl.dart';
import 'package:thankyoulist/crypto.dart';

class ThankYouUpdateModel {
  final String id;
  final String encryptedValue;
  final DateTime date;
  final DateTime createdDate;

  ThankYouUpdateModel({
    this.id,
    this.encryptedValue,
    this.date,
    this.createdDate
  });

  factory ThankYouUpdateModel.from({String id, String value, DateTime date, String userId}) {
    return ThankYouUpdateModel(
        id: id,
        encryptedValue: Crypto().encryptAESCrypto(value, userId.substring(0, 16)),
        date: date,
        createdDate: DateTime.now()
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'encryptedValue': encryptedValue,
    'date': DateFormat('yyyy/MM/dd').format(date),
    'createTime': createdDate
  };
}