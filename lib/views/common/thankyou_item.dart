import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thankyoulist/app_colors.dart';

import 'package:thankyoulist/models/thankyou_model.dart';

class ThankYouItem extends StatelessWidget {
  ThankYouItem({
    required this.thankYou,
    required this.onEditButtonPressed,
    required this.onDeleteButtonPressed
  });

  final ThankYouModel thankYou;
  final Function onEditButtonPressed;
  final Function onDeleteButtonPressed;

  final Color textColor = AppColors.textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 5.0)
                )
              ]
          ),
          margin: EdgeInsets.symmetric(
              vertical: 0.0,
              horizontal: 24.0
          ),
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 140,
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: SizedBox(
                            width: 96,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat("dd").format(thankYou.date),
                                    style: _dateTextStyle(textSize: 23),
                                  ),
                                  Text(
                                    DateFormat("MMM").format(thankYou.date),
                                    style: _dateTextStyle(textSize: 14),
                                  )
                                ]
                            ),
                          )
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.black26,
                      thickness:  0.5,
                    ),
                    Flexible(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(12, 16, 16, 16),
                          child: Text(thankYou.value,
                            style: TextStyle(
                                color: textColor,
                                fontSize: 15.0
                            ),
                          ),
                        )
                    )
                  ],
                ),
              )
          ),
        ),
        onTap: () => _showEditDeleteBottomSheet(context),
      )
    );
  }

  TextStyle _dateTextStyle({required double textSize}) {
    return TextStyle(
        color: textColor,
        fontSize: textSize,
        fontWeight: FontWeight.w600
    );
  }

  void _showEditDeleteBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
          )
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 20,
              alignment: Alignment.center,
              child: Container(
                height: 4,
                width: 36,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black12
                ),
              ),
            ),
            ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  onEditButtonPressed();
                }
            ),
            ListTile(
                leading: Icon(Icons.delete_rounded),
                title: Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  onDeleteButtonPressed();
                }
            ),
          ],
        );
      }
    );
  }
}