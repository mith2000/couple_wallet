part 'app_exception.dart';
part 'app_result_model.dart';

abstract class BaseModel {}

class EmptyModel extends BaseModel {}

class DateTimeModelFormatter {
  static DateTime? fromJson(dynamic dateTime) =>
      DateTime.tryParse(dateTime?.toString() ?? '');

  static String? toJson(DateTime? dateTime) =>
      dateTime?.toUtc().toIso8601String();
}
