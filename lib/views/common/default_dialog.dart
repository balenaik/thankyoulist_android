import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultDialog extends StatelessWidget {
  final String title;
  final String message;
  final String positiveButtonTitle;
  final String negativeButtonTitle;
  final Function? onPositiveButtonPressed;
  final Function? onNegativeButtonPressed;

  DefaultDialog(this.title, this.message,
      {this.positiveButtonTitle = 'OK',
        this.negativeButtonTitle = 'Cancel',
        this.onPositiveButtonPressed,
        this.onNegativeButtonPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        if (onPositiveButtonPressed != null)
          FlatButton(
            child: Text(positiveButtonTitle),
            onPressed: () {
              Navigator.pop(context);
              onPositiveButtonPressed!();
            },
          ),
        if (onNegativeButtonPressed != null)
          FlatButton(
            child: Text(negativeButtonTitle),
            onPressed: () {
              Navigator.pop(context);
              onNegativeButtonPressed!();
            },
          )
      ],
    );
  }
}
