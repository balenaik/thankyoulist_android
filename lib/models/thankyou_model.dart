import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:thankyoulist/crypto.dart';

class ThankYouModel {
  final String id;
  final String value;
  final String encryptedValue;
  final DateTime date;
  final DateTime createdDate;

  ThankYouModel({
    required this.id,
    required this.value,
    required this.encryptedValue,
    required this.date,
    required this.createdDate
  });

  factory ThankYouModel.fromJson({
    required Map<String, dynamic> json,
    required String documentId,
    required String userId
  }) {
    DateTime createdDate = DateTime.now();
    final createTime = json['createTime'];
    if (createTime is Timestamp) {
      createdDate = createTime.toDate();
    }
    return ThankYouModel(
      id: documentId,
      value: Crypto().decryptAESCrypto(json['encryptedValue'], userId.substring(0, 16)),
      encryptedValue: json['encryptedValue'],
      date: DateFormat('yyyy/MM/dd').parse(json['date']),
      createdDate: createdDate,
    );
  }
}