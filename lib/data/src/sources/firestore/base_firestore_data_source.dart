import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../domain/domain.dart';
import '../../../../utilities/logs.dart';
import '../../raws/base_raw.dart';

part 'chat_firestore_data_source.dart';

const String chatCollection = "chats";

final FirebaseFirestore _instance = FirebaseFirestore.instance;

final class FirestoreException {
  static void onError(Object e) =>
      Logs.e("FirebaseFirestore Error completing: ${e.toString()}");
}
