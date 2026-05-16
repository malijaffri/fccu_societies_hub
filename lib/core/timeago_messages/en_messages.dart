import 'package:timeago/timeago.dart' as timeago;

class EnMessages extends timeago.EnMessages {
  @override
  String prefixFromNow() => 'in';
  @override
  String suffixFromNow() => '';
}
