import 'package:intl/intl.dart';

class DateUtilsX {
  static String toHuman(DateTime dt) {
    return DateFormat.yMMMd().add_jm().format(dt.toLocal());
  }

  static String toIso(DateTime dt) {
    final s = dt.toUtc().toIso8601String();
    if (s.contains('.')) {
      return s.split('.').first + 'Z';
    }
    return s;
  }
}

