import 'package:thankyoulist/models/thankyou_model.dart';

class ThankYouListViewUiModel {
  final SectionMonthYearModel? sectionMonthYear;
  final ThankYouModel? thankYou;

  ThankYouListViewUiModel({
    this.sectionMonthYear,
    this.thankYou,
  });
}

class SectionMonthYearModel implements Comparable<SectionMonthYearModel> {
  final int month;
  final int year;

  SectionMonthYearModel({
    required this.month,
    required this.year,
  });

  @override
  int compareTo(SectionMonthYearModel other) {
    int selfNum = year * 100 + month;
    int otherNum = other.year * 100 + other.month;
    return selfNum - otherNum;
  }
}