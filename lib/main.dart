import 'package:flutter/material.dart';

import 'package:thankyoulist/launch_screen.dart';

void main() => runApp(ThankYouListApp());

class ThankYouListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thank You List',
      home: LaunchScreen()
    );
  }
}