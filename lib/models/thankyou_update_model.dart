import 'dart:core';
import 'package:intl/intl.dart';
import 'package:thankyoulist/crypto.dart';

class ThankYouUpdateModel {
  final String id;
  final String encryptedValue;
  final DateTime date;
  final DateTime createdDate;

  ThankYouUpdateModel({
    required this.id,
    required this.encryptedValue,
    required this.date,
    required this.createdDate
  });

  factory ThankYouUpdateModel.from({
    required String id,
    required String value,
    required DateTime date,
    required String userId}) {
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