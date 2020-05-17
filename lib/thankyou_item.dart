import 'package:flutter/material.dart';

class ThankYouItem extends StatelessWidget {
  ThankYouItem({
    Key key,
    this.title,
    this.subtitle,
    this.author,
    this.publishDate,
    this.readDuration,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;

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
                            Text('14'),
                            Text('Apr')
                          ]
                      ),
                    )
                ),
              ),
              Container(
                padding: EdgeInsets.all(12),
                child: Text('abc\nabc\nabc\n\nabc\nabc\nabc\nabc\n\n\n\n\nabc'),
              )
            ],
          ),
        ),
      ),
    );
  }
}