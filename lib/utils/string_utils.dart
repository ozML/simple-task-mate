import 'package:collection/collection.dart';

class StringUtils {
  StringUtils._();

  static String join(List<String?> parts, {String separator = '-'}) =>
      parts.whereNotNull().join(separator);
}
