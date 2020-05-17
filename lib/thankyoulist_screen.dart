import 'package:flutter/material.dart';
import 'package:thankyoulist/thankyou_item.dart';

class ThankYouListScreen extends StatelessWidget {
  final Color color;
  final List<String> listItem = ["one", "two", "three"];

  ThankYouListScreen(this.color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thank You List'),
      ),
      backgroundColor: color,
      body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return ThankYouItem();
          },
          itemCount: listItem.length)
    );
  }
}