import 'package:get/get.dart';

import '../theme/theme_controller.dart';
import 'app_error_handling_service.dart';
import 'app_network_connection.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() async {
    Get.put<NetworkConnectionService>(NetworkConnectionService(),
        permanent: true);
    Get.put<AppErrorHandlingService>(AppErrorHandlingService(),
        permanent: true);
    Get.put<ThemeController>(ThemeController());

    // // Inject dependencies
    // await DataProvider.inject();
    // await DomainProvider.inject();
  }
}
