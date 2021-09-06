import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thankyoulist/app_colors.dart';
import 'package:thankyoulist/views/themes/light_theme.dart';

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
      title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold)
      ),
      content: Text(message),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))
      ),
      actions: <Widget>[
        if (onNegativeButtonPressed != null)
          TextButton(
            child: Text(
                negativeButtonTitle,
                style: TextStyle(
                  color: AppColors.textColor,
                )
            ),
            onPressed: () {
              Navigator.pop(context);
              onNegativeButtonPressed!();
            },
          ),
        if (onPositiveButtonPressed != null)
          TextButton(
            child: Text(
              positiveButtonTitle,
              style: TextStyle(
                  color: primaryColor[900],
                  fontWeight: FontWeight.bold
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              onPositiveButtonPressed!();
            },
          ),
      ],
    );
  }
}
