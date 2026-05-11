import 'package:intl/intl.dart';

String formatNumber(int number) {
  if (number < 1000) return number.toString();

  return NumberFormat.compact().format(number);
}
