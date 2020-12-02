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
}
