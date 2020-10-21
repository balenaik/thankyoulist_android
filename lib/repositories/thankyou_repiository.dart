import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thankyoulist/models/thankyou_create_model.dart';

const USERS_COLLECTION = 'users';
const THANKYOULIST_COLLECTION = 'thankYouList';

abstract class ThankYouRepository {
  Future<void> createThankYou(String userId, ThankYouCreateModel thankYouCreate);
}

class ThankYouRepositoryImpl implements ThankYouRepository {
  ThankYouRepositoryImpl({ @required this.firestore })
      : assert(firestore != null);

  final Firestore firestore;

  @override
  Future<void> createThankYou(String userId, ThankYouCreateModel thankYouCreate) async {
    return await firestore
          .collection(USERS_COLLECTION)
          .document(userId)
          .collection(THANKYOULIST_COLLECTION)
          .add(thankYouCreate.toJson());
  }
}