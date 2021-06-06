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
    required this.type,
    required this.thankYou
  });
}

abstract class ThankYouListRepository {
  Stream<List<ThankYouListChange>> addThankYouListener(String userId);
}

class ThankYouListRepositoryImpl implements ThankYouListRepository {
  ThankYouListRepositoryImpl({ required this.firestore })
    : assert(firestore != null);

  final FirebaseFirestore firestore;

  @override
  Stream<List<ThankYouListChange>> addThankYouListener(String userId) {
    return firestore
        .collection(USERS_COLLECTION)
        .doc(userId)
        .collection(THANKYOULIST_COLLECTION)
        .snapshots()
        .map((snapshot) {
          return snapshot.docChanges.map( (change) {
            final json = change.doc.data();
            if (json == null) {
              return null;
            }
            ThankYouModel thankYou = ThankYouModel.fromJson(
                json: json,
                documentId: change.doc.id,
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
          }
          ).whereType<ThankYouListChange>().toList();
        }
    );
  }
}