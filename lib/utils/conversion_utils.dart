import 'dart:convert';

T? tryDecodeJson<T>(String json, {T? Function(dynamic data)? convert}) {
  try {
    final data = jsonDecode(json);

    if (convert != null) {
      return convert(data);
    } else if (data is T) {
      return data;
    }
  } on Exception catch (_) {}

  return null;
}
