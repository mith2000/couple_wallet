import 'package:get/get.dart';

import '../../domain/domain.dart';
import 'repositories/chat_repository_impl.dart';
import 'sources/firestore/base_firestore_data_source.dart';

class DataProvider {
  static Future<void> inject() async {
    _DataSourceProvider.inject();
    _RepoProvider.inject();
  }
}

class _DataSourceProvider {
  static void inject() {
    Get.put<ChatRemoteDataSource>(ChatRemoteDataSourceImpl());
  }
}

class _RepoProvider {
  static void inject() {
    Get.put<ChatRepository>(ChatRepositoryImpl(Get.find()));
  }
}
