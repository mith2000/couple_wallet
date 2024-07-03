import 'package:get/get.dart';

import 'usecases/base_use_case.dart';

class DomainProvider {
  static void inject() {
    Get.put<GetChatSessionUseCase>(GetChatSessionUseCaseImpl(Get.find()));
    Get.put<SendMessageUseCase>(SendMessageUseCaseImpl(Get.find()));
    Get.put<GetLoveInfoUseCase>(GetLoveInfoUseCaseImpl());
  }
}
