import 'package:timeago/timeago.dart' as timeago;

class EnShortMessages extends timeago.EnShortMessages {
  @override
  String prefixFromNow() => 'in';
  @override
  String suffixAgo() => 'ago';
  @override
  String lessThanOneMinute(int seconds) => 'seconds';
}
