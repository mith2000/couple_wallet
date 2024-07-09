import 'package:uuid/uuid.dart';

import '../../domain.dart';

part 'app_list_param.dart';
part 'chat_query_param.dart';
part 'send_message_param.dart';

abstract class BaseParam {}

class SimpleParam<T> extends BaseParam {
  final T value;

  SimpleParam(this.value);
}

class UUIDGenerator {
  static String generate() => const Uuid().v4();
}
