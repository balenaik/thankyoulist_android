import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:thankyoulist/models/thankyou_model.dart';
import 'package:thankyoulist/models/thankyou_create_model.dart';
import 'package:thankyoulist/models/thankyou_update_model.dart';

const USERS_COLLECTION = 'users';
const THANKYOULIST_COLLECTION = 'thankYouList';

abstract class ThankYouRepository {
  Future<ThankYouModel> fetchThankYou(String userId, String id);
  Future<void> createThankYou(String userId, ThankYouCreateModel thankYouCreate);
  Future<void> updateThankYou(String userId, ThankYouUpdateModel thankYouUpdate);
  Future<void> deleteThankYou(String userId, String thankYouId);
}

class ThankYouRepositoryImpl implements ThankYouRepository {
  ThankYouRepositoryImpl({ @required this.firestore })
      : assert(firestore != null);

  final Firestore firestore;

  @override
  Future<ThankYouModel> fetchThankYou(String userId, String id) async {
    final thankYouDocument = await firestore
        .collection(USERS_COLLECTION)
        .document(userId)
        .collection(THANKYOULIST_COLLECTION)
        .document(id)
        .get();
    return ThankYouModel.fromJson(json: thankYouDocument.data, documentId: id, userId: userId);
  }

  @override
  Future<void> createThankYou(String userId, ThankYouCreateModel thankYouCreate) async {
    return await firestore
          .collection(USERS_COLLECTION)
          .document(userId)
          .collection(THANKYOULIST_COLLECTION)
          .add(thankYouCreate.toJson());
  }

  @override
  Future<void> updateThankYou(String userId, ThankYouUpdateModel thankYouUpdate) async {
    return await firestore
        .collection(USERS_COLLECTION)
        .document(userId)
        .collection(THANKYOULIST_COLLECTION)
        .document(thankYouUpdate.id)
        .updateData(thankYouUpdate.toJson());
  }

  @override
  Future<void> deleteThankYou(String userId, String thankYouId) async {
    return await firestore
        .collection(USERS_COLLECTION)
        .document(userId)
        .collection(THANKYOULIST_COLLECTION)
        .document(thankYouId)
        .delete();
  }
}