part of 'home_controller.dart';

const backgroundColor = Color(0xffFCF1DE);
const onBackgroundColor = Color(0xff2B2A28);

const screens = [
  SendLoveScreen(),
  RecordScreen(),
  StatisticScreen(),
  SettingScreen(),
];

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: body(context),
        bottomNavigationBar: Obx(
          () => HomeNavBar(
            selectedIndex: controller.selectedIndex.value,
            onTabChange: controller.onTabChange,
          ),
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    return PageView(
      controller: controller.pageController,
      onPageChanged: controller.onPageChange,
      children: screens,
    );
  }
}
