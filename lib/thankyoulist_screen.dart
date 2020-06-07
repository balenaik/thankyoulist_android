import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:thankyoulist/thankyou_item.dart';
import 'package:thankyoulist/crypto.dart';

class ThankYouListScreen extends StatelessWidget {
  final Color color;
  FirebaseAuth auth = FirebaseAuth.instance;
  String userId;

  ThankYouListScreen(this.color);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _getThankYouList(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return Scaffold(
                appBar: AppBar(
                  title: Text('Thank You List'),
                ),
                backgroundColor: color,
                body: ListView(
                  children: snapshot.data.documents.map((DocumentSnapshot document) {
                    return ThankYouItem(
                      thankYou: Crypto().decryptAESCrypto(document['encryptedValue'], userId.substring(0, 16)),
                    );
                  }).toList(),
                )
            );
        }
      },
    );
  }

  Stream<QuerySnapshot> _getThankYouList() async* {
    FirebaseUser user = await auth.currentUser();
    userId = user.uid;
    var snapshots = Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('thankYouList')
        .snapshots();
    yield* snapshots;
  }
}