import 'package:uuid/uuid.dart';

import '../models/base_model.dart';

part 'app_list_param.dart';
part 'chat_query_param.dart';
part 'send_message_param.dart';

abstract class BaseParam {}

class UUIDGenerator {
  static String generate() => const Uuid().v4();
}
