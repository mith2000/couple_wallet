import 'package:get/get.dart';

import '../pages/home/home_controller.dart';
import '../pages/sample/sample_controller.dart';
import '../pages/uikit/animations/animation_sample_page.dart';
import '../pages/uikit/uikit_controller.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: Routes.sample,
      page: () => const SamplePage(),
      binding: SampleBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.uikit,
      page: () => const UIKitPage(),
      binding: UIKitBinding(),
    ),
    GetPage(
      name: Routes.animation,
      page: () => const OpenContainerTransformDemo(),
    ),
  ];
}
