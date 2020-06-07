import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:thankyoulist/models/thankyou.dart';

class ThankYouItem extends StatelessWidget {
  ThankYouItem({
    this.thankYou,
  });

  final ThankYou thankYou;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
            vertical: 8.0,
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
                              Text(DateFormat("dd").format(thankYou.date)),
                              Text(DateFormat("MMM").format(thankYou.date))
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
                      child: Text(thankYou.value),
                    )
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}