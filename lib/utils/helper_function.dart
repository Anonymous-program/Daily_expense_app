import 'package:intl/intl.dart';

String getFormattedDate(DateTime dt, {String pattern = 'dd/MM/yyyy'}) {
  return DateFormat(pattern).format(dt);
}
// String getFormattedDate(dt) => DateFormat('dd/MM/yyyy').format(dt);
