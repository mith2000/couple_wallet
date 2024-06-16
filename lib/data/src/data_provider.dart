import 'package:get/get.dart';

import '../../domain/src/repositories/base_repository.dart';
import 'remote/base_remote_data_source.dart';
import 'repositories/chat_repository_impl.dart';

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
