import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../domain/domain.dart';
import '../../../../utilities/logs.dart';
import '../../keys/app_key.dart';
import '../../services/app_shared_pref.dart';

part 'shared_pref_local_data_source.dart';

final class LocalExceptionLogs {
  static void onError(Object e) =>
      Logs.e("Local Data Source Error: ${e.toString()}");
}

final class LocalHandleError {
  static Exception unknown(Object e) {
    throw LocalException(
      code: ErrorCode.code9999,
      message: 'Something went wrong: ${e.toString()}',
      errorCode: ErrorCode.unknownLocalServiceError,
    );
  }
}
