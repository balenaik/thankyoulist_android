import 'package:flutter/material.dart';

class RemoveGlowingOverScrollIndicatorBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}