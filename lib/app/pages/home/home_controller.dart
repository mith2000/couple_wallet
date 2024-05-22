import 'package:couple_wallet/app/components/feature/home/home_app_bar.dart';
import 'package:couple_wallet/app/components/feature/home/home_nav_bar.dart';
import 'package:couple_wallet/app/pages/home/screens/love/send_love_controller.dart';
import 'package:couple_wallet/app/pages/home/screens/record_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/bills_screen.dart';
import 'screens/setting_screen.dart';

part 'home_binding.dart';
part 'home_page.dart';

class HomeController extends GetxController {
  PageController pageController = PageController();
  RxInt selectedIndex = 0.obs;

  final DateTime loveStartDate = DateTime(2022, 11, 13);

  @override
  void onInit() {
    Get.put<SendLoveController>(SendLoveController());
    super.onInit();
  }

  void onPageChange(int page) {
    selectedIndex.value = page;
  }

  void onTabChange(int index) {
    onPageChange(index);
    pageController.jumpToPage(index);
  }

  String countLoveDays() {
    final now = DateTime.now();
    final days = now.difference(loveStartDate).inDays;
    return '$days';
  }
}
