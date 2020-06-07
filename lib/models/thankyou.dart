import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:thankyoulist/crypto.dart';

class ThankYou {
  final String id;
  final String value;
  final String encryptedValue;
  final DateTime date;
  final DateTime createdDate;

  ThankYou({
    this.id,
    this.value,
    this.encryptedValue,
    this.date,
    this.createdDate
  });

  factory ThankYou.fromJson({Map<String, dynamic> json, String documentId, String userId}) {
    DateTime createdDate;
    final createTime = json['createTime'];
    if (createTime is Timestamp) {
      createdDate = createTime.toDate();
    }
    return ThankYou(
      id: documentId,
      value: Crypto().decryptAESCrypto(json['encryptedValue'], userId.substring(0, 16)),
      encryptedValue: json['encryptedValue'],
      date: DateFormat('yyyy/MM/dd').parse(json['date']),
      createdDate: createdDate,
    );
  }
}