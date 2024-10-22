import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/domain.dart';
import '../../../resources/resources.dart';
import '../../../utilities/logs.dart';
import '../../components/feature/home/home_nav_bar.dart';
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
  final GetUserInfoUseCase getUserInfoUseCase;
  final RegisterUserUseCase registerUserUseCase;
  final GetUserFcmTokenUseCase getUserFcmTokenUseCase;

  PageController pageController = PageController();
  RxInt selectedIndex = 0.obs;

  HomeController({
    required this.getUserIDUseCase,
    required this.getUserInfoUseCase,
    required this.registerUserUseCase,
    required this.getUserFcmTokenUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    fetchUserInfo();
  }

  void fetchUserInfo() async {
    String userId = await getUserID();
    await getUserInfo(userId);
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
        Get.find<AppErrorHandlingService>()
            .showErrorSnackBar(R.strings.userIDNotFound.tr);
        return '';
      }
      Get.find<AppErrorHandlingService>()
          .showErrorSnackBar(e.message ?? e.errorCode ?? '');
    }
    return '';
  }

  Future<void> getUserInfo(String userId) async {
    try {
      final response = await getUserInfoUseCase(request: SimpleParam(userId));
      final data = response.netData;
      if (data is UserModel) {
        // Save user info
      }
    } on AppException catch (e) {
      Logs.e("getUserInfo failed with ${e.toString()}");
      if (e.errorCode == ErrorCode.lackOfInputError) {
        Get.find<AppErrorHandlingService>()
            .showErrorSnackBar(R.strings.missingUserId.tr);
        return;
      }
      if (e.errorCode == ErrorCode.notFoundError) {
        registerUser(userId);
        return;
      }
      Get.find<AppErrorHandlingService>()
          .showErrorSnackBar(e.message ?? e.errorCode ?? '');
    }
  }

  Future<void> registerUser(String userId) async {
    try {
      final deviceID = await getDeviceID();
      final fcmToken = await getUserFCMToken();
      await registerUserUseCase(
        request: RegisterUserParam(
          id: userId,
          deviceId: deviceID,
          fcmToken: fcmToken,
        ),
      );
    } on AppException catch (e) {
      Logs.e("registerUser failed with ${e.toString()}");
      if (e.errorCode == ErrorCode.lackOfInputError) {
        Get.find<AppErrorHandlingService>().showErrorSnackBar(e.message ?? '');
        return;
      }
      if (e.errorCode == ErrorCode.alreadyExistedError) {
        Get.find<AppErrorHandlingService>()
            .showErrorSnackBar(e.message ?? e.errorCode ?? '');
        return;
      }
      Get.find<AppErrorHandlingService>()
          .showErrorSnackBar(e.message ?? e.errorCode ?? '');
    }
  }

  Future<String> getDeviceID() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor ?? 'iOS Info not found';
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    }
    return 'N/A';
  }

  Future<String> getUserFCMToken() async {
    try {
      final response = await getUserFcmTokenUseCase();
      final value = (response.netData as SimpleModel<String?>).value;
      if (value != null && value.isNotEmpty) {
        return value;
      }
    } on AppException catch (e) {
      Logs.e("getUserFCMToken failed with ${e.toString()}");
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
