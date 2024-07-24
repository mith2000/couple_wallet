part of 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ShortcutBottomSheetController>(
      ShortcutBottomSheetController(pref: Get.find()),
    );
    Get.put<ListMessageController>(
      ListMessageController(
        getUserFcmTokenUseCase: Get.find(),
        getPartnerFcmTokenUseCase: Get.find(),
        getChatSessionUseCase: Get.find(),
      ),
    );
    Get.put<SendLoveController>(
      SendLoveController(
        getLoveInfoUseCase: Get.find(),
        sendMessageUseCase: Get.find(),
        shortcutBottomSheetController: Get.find<ShortcutBottomSheetController>(),
        listMessageController: Get.find<ListMessageController>(),
      ),
    );
    Get.put<SettingController>(
      SettingController(
        getUserFcmTokenUseCase: Get.find(),
        getPartnerFcmTokenUseCase: Get.find(),
        savePartnerFcmTokenUseCase: Get.find(),
      ),
    );
    Get.put<HomeController>(
      HomeController(
        getUserIDUseCase: Get.find(),
        getUserInfoUseCase: Get.find(),
      ),
    );
  }
}
