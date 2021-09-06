import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:thankyoulist/models/thankyou_model.dart';
import 'package:thankyoulist/models/thankyou_create_model.dart';
import 'package:thankyoulist/models/thankyou_update_model.dart';

const USERS_COLLECTION = 'users';
const THANKYOULIST_COLLECTION = 'thankYouList';

class ThankYouException implements Exception {}
class ThankYouUnableToConvertToJsonException implements ThankYouException {}

abstract class ThankYouRepository {
  Future<ThankYouModel> fetchThankYou(String userId, String id);
  Future<void> createThankYou(String userId, ThankYouCreateModel thankYouCreate);
  Future<void> updateThankYou(String userId, ThankYouUpdateModel thankYouUpdate);
  Future<void> deleteThankYou(String userId, String thankYouId);
}

class ThankYouRepositoryImpl implements ThankYouRepository {
  ThankYouRepositoryImpl({ required this.firestore })
      : assert(firestore != null);

  final FirebaseFirestore firestore;

  @override
  Future<ThankYouModel> fetchThankYou(String userId, String id) async {
    final thankYouDocument = await firestore
        .collection(USERS_COLLECTION)
        .doc(userId)
        .collection(THANKYOULIST_COLLECTION)
        .doc(id)
        .get();
    final json = thankYouDocument.data();
    if (json == null) {
      throw ThankYouUnableToConvertToJsonException();
    }
    return ThankYouModel.fromJson(json: json, documentId: id, userId: userId);
  }

  @override
  Future<void> createThankYou(String userId, ThankYouCreateModel thankYouCreate) async {
    await firestore
        .collection(USERS_COLLECTION)
        .doc(userId)
        .collection(THANKYOULIST_COLLECTION)
        .add(thankYouCreate.toJson());
  }

  @override
  Future<void> updateThankYou(String userId, ThankYouUpdateModel thankYouUpdate) async {
    return await firestore
        .collection(USERS_COLLECTION)
        .doc(userId)
        .collection(THANKYOULIST_COLLECTION)
        .doc(thankYouUpdate.id)
        .update(thankYouUpdate.toJson());
  }

  @override
  Future<void> deleteThankYou(String userId, String thankYouId) async {
    return await firestore
        .collection(USERS_COLLECTION)
        .doc(userId)
        .collection(THANKYOULIST_COLLECTION)
        .doc(thankYouId)
        .delete();
  }
}