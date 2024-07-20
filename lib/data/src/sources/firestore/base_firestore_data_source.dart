import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../domain/domain.dart';
import '../../../../utilities/logs.dart';
import '../../raws/base_raw.dart';

part 'chat_firestore_data_source.dart';

const String chatCollection = "chats";

const String firestorePermissionDeniedCode = 'permission-denied';

final FirebaseFirestore _instance = FirebaseFirestore.instance;

final class FirestoreExceptionLogs {
  static void onError(Object e) => Logs.e("FirebaseFirestore Error completing: ${e.toString()}");
}

final class FirestoreHandleError {
  static Exception handleFirestoreException(FirebaseException e) {
    switch (e.code) {
      case firestorePermissionDeniedCode:
        return permissionDenied(e);
      default:
        FirestoreExceptionLogs.onError(e);
        return unknown(e);
    }
  }

  static Exception permissionDenied(FirebaseException e) {
    throw NetworkException(
      code: ErrorCode.code403,
      message: e.message ?? e.code,
      errorCode: firestorePermissionDeniedCode,
    );
  }

  static Exception unknown(Object e) {
    throw NetworkException(
      code: ErrorCode.code9999,
      message: 'Something went wrong: ${e.toString()}',
      errorCode: ErrorCode.unknownNetworkServiceError,
    );
  }
}
