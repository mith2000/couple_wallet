import 'package:get/get.dart';

import '../../domain/domain.dart';
import 'repositories/chat_repository_impl.dart';
import 'repositories/shared_pref_repository_impl.dart';
import 'sources/firestore/base_firestore_data_source.dart';
import 'sources/local/base_local_data_source.dart';

class DataProvider {
  static Future<void> inject() async {
    await _DataSourceProvider.inject();
    await _RepoProvider.inject();
  }
}

class _DataSourceProvider {
  static Future<void> inject() async {
    // Firestore
    Get.put<ChatRemoteDataSource>(ChatRemoteDataSourceImpl());

    // Local
    Get.put<SharedPrefLocalDataSource>(SharedPrefLocalDataSourceImpl(Get.find()));
  }
}

class _RepoProvider {
  static Future<void> inject() async {
    Get.put<ChatRepository>(ChatRepositoryImpl(Get.find()));
    Get.put<SharedPrefRepository>(SharedPrefRepositoryImpl(Get.find()));
  }
}
