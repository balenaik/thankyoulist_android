import 'package:thankyoulist/app_data_store.dart';

abstract class AppDataRepository {
  DateTime? loadCalendarSelectedDate();
  void writeCalendarSelectedDate(DateTime date);
}

class AppDataRepositoryImpl implements AppDataRepository {
  AppDataRepositoryImpl({ required this.appDataStore });

  final AppDataStore appDataStore;

  @override
  DateTime? loadCalendarSelectedDate() {
    return appDataStore.calendarSelectedDate;
  }

  @override
  void writeCalendarSelectedDate(DateTime date) {
    appDataStore.calendarSelectedDate = date;
  }
}