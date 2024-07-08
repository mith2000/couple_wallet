import 'package:get/get.dart';

import '../domain.dart';

class DomainProvider {
  static void inject() {
    Get.put<GetChatSessionUseCase>(GetChatSessionUseCaseImpl(Get.find()));
    Get.put<SendMessageUseCase>(SendMessageUseCaseImpl(Get.find()));
    Get.put<GetLoveInfoUseCase>(GetLoveInfoUseCaseImpl());
  }
}
