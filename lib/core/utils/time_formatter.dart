import 'package:intl/intl.dart';

class TimeFormatter {
  TimeFormatter._();

  static String format(DateTime time) {
    final difference = DateTime.now().difference(time);

    return difference.isNegative ? formatFuture(time) : formatPast(time);
  }

  static String formatPast(DateTime time) {
    final difference = DateTime.now().difference(time);

    if (difference.inSeconds < 10) return 'Just now';
    if (difference.inMinutes < 1) return '${difference.inSeconds}s ago';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    return DateFormat.yMMMd().format(time);
  }

  static String formatFuture(DateTime time) {
    final difference = time.difference(DateTime.now());

    if (difference.inSeconds < 10) return 'Now';
    if (difference.inMinutes < 1) return 'In ${difference.inSeconds}s';
    if (difference.inHours < 1) return 'In ${difference.inMinutes}m';
    if (difference.inDays < 1) return 'In ${difference.inHours}h';
    if (difference.inDays < 7) return 'In ${difference.inDays}d';

    return DateFormat.yMMMd().format(time);
  }
}
