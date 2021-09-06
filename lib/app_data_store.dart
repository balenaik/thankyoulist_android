class AppDataStore {

  static final AppDataStore _appDataStore = new AppDataStore._internal();

  factory AppDataStore() {
    return _appDataStore;
  }

  AppDataStore._internal();

  DateTime? calendarSelectedDate;
}