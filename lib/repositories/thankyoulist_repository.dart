import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:thankyoulist/models/thankyou_model.dart';
import 'package:thankyoulist/repositories/model_change_type.dart';

const USERS_COLLECTION = 'users';
const THANKYOULIST_COLLECTION = 'thankYouList';

class ThankYouListChange {
  final ModelChangeType type;
  final ThankYouModel thankYou;

  ThankYouListChange({
    this.type,
    this.thankYou
  });
}

abstract class ThankYouListRepository {
  Stream<List<ThankYouListChange>> addThankYouListener(String userId);
}

class ThankYouListRepositoryImpl implements ThankYouListRepository {
  ThankYouListRepositoryImpl({ @required this.firestore })
    : assert(firestore != null);

  final Firestore firestore;

  @override
  Stream<List<ThankYouListChange>> addThankYouListener(String userId) {
    return firestore
        .collection(USERS_COLLECTION)
        .document(userId)
        .collection(THANKYOULIST_COLLECTION)
        .snapshots()
        .map((snapshot) {
          return snapshot.documentChanges.map( (change) {
            ThankYouModel thankYou = ThankYouModel.fromJson(
                json: change.document.data,
                documentId: change.document.documentID,
                userId: userId
            );
            switch (change.type) {
              case DocumentChangeType.added:
                return ThankYouListChange(type: ModelChangeType.added, thankYou: thankYou);
              case DocumentChangeType.modified:
                return ThankYouListChange(type: ModelChangeType.modified, thankYou: thankYou);
              case DocumentChangeType.removed:
                return ThankYouListChange(type: ModelChangeType.removed, thankYou: thankYou);
              default:
                // Nothing should come here
                return ThankYouListChange(type: ModelChangeType.added, thankYou: thankYou);
            }
          }).toList();
        }
    );
  }
}