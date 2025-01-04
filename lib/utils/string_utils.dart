class StringUtils {
  StringUtils._();

  static String join(List<String?> parts, {String separator = '-'}) =>
      parts.nonNulls.join(separator);
}
