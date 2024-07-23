import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/domain.dart';
import '../../../resources/resources.dart';
import '../../../utilities/logs.dart';
import '../../components/feature/home/home_nav_bar.dart';
import '../../components/feature/shortcut/bottomSheet/shortcut_bottom_sheet_controller.dart';
import '../../services/app_error_handling_service.dart';
import 'screens/love/messages/list_message_controller.dart';
import 'screens/love/send_love_controller.dart';
import 'screens/record_screen.dart';
import 'screens/setting/setting_controller.dart';
import 'screens/statistic_screen.dart';

part 'home_binding.dart';
part 'home_page.dart';

class HomeController extends GetxController {
  final GetUserIDUseCase getUserIDUseCase;

  PageController pageController = PageController();
  RxInt selectedIndex = 0.obs;

  HomeController({required this.getUserIDUseCase});

  @override
  void onInit() {
    super.onInit();
    fetchUserInfo();
  }

  void fetchUserInfo() async {
    String userId = await getUserID();
    Logs.i("Waiting to fetch user info. User ID: $userId");
    // TODO Fetch user info
  }

  Future<String> getUserID() async {
    try {
      final response = await getUserIDUseCase();
      final value = (response.netData as SimpleModel<String>).value;
      if (value != null && value.isNotEmpty) {
        return value;
      }
    } on AppException catch (e) {
      Logs.e("getUserID failed with ${e.toString()}");
      if (e.errorCode == ErrorCode.lackOfInputError) {
        Get.find<AppErrorHandlingService>().showErrorSnackBar(R.strings.userIDNotFound.tr);
        return '';
      }
      Get.find<AppErrorHandlingService>().showErrorSnackBar(e.message ?? e.errorCode ?? '');
    }
    return '';
  }

  void onPageChange(int page) {
    selectedIndex.value = page;
  }

  void onTabChange(int index) {
    onPageChange(index);
    pageController.jumpToPage(index);
  }

  void goSetting() {
    onTabChange(3);
  }
}
