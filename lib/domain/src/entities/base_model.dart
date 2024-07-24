import 'package:intl/intl.dart';

part 'app_exception.dart';
part 'app_result_model.dart';
part 'chat_model.dart';
part 'love_info_model.dart';
part 'message_model.dart';
part 'user_model.dart';

abstract class BaseModel {}

class EmptyModel extends BaseModel {}

class SimpleModel<T> extends BaseModel {
  final T? value;

  SimpleModel(this.value);
}

class MapJson {
  static Map<String, dynamic> removeJsonIfNull(Map<String, dynamic> json) {
    final returnJson = {...json};
    returnJson.removeWhere((key, value) =>
        value == null ||
        value == null.toString() ||
        (value is String && value.isEmpty) ||
        (value is List && value.isEmpty));
    return returnJson;
  }
}

class StringJson {
  static String fromJson(dynamic value) => value.toString();
}

class DoubleJson {
  static double fromJson(dynamic value) => double.tryParse(StringJson.fromJson(value)) ?? 0.0;
}

class IntJson {
  static int fromJson(dynamic value) => int.tryParse(StringJson.fromJson(value)) ?? 0;
}

class DateTimeModelFormatter {
  static DateTime? fromJson(dynamic dateTime) => DateTime.tryParse(dateTime?.toString() ?? '');

  static String? toJson(DateTime? dateTime) => dateTime?.toUtc().toIso8601String();

  static DateTime? fromJsonWithFormat(dynamic dateTime, String format) {
    try {
      return DateFormat(format).parse(dateTime?.toString() ?? '');
    } catch (e) {
      return DateTime.now();
    }
  }
}
