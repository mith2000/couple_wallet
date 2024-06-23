import 'package:get/get.dart';

import '../../data/data.dart';
import '../../domain/domain.dart';
import '../theme/theme_controller.dart';
import 'app_network_connection.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<NetworkConnectionService>(NetworkConnectionService(),
        permanent: true);
    Get.put<ThemeController>(ThemeController());

    // Inject dependencies
    DataProvider.inject();
    DomainProvider.inject();
  }
}
