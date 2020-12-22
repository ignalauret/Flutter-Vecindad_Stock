class Utils {
  static bool isSameDay(DateTime d1, DateTime d2) {
    return d1.day == d2.day && d1.month == d2.month && d1.year == d2.year;
  }

  static bool isNumber(String value) {
    try {
      int.parse(value);
      return true;
    } catch(_) {
      return false;
    }
  }

  static DateTime get openDate {
    final now = DateTime.now().subtract(Duration(hours: 7));
    return DateTime(now.year, now.month, now.day, 7);
  }

  static DateTime get closeDate {
    final tomorrow = DateTime.now().add(Duration(hours: 17));
    return DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 7);
  }
}
