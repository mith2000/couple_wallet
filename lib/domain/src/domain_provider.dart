import 'package:get/get.dart';

import '../domain.dart';

class DomainProvider {
  static Future<void> inject() async {
    Get.put<GetChatSessionUseCase>(GetChatSessionUseCaseImpl(Get.find()));
    Get.put<SendMessageUseCase>(SendMessageUseCaseImpl(Get.find()));
    Get.put<GetLoveInfoUseCase>(GetLoveInfoUseCaseImpl());
    Get.put<GetUserFcmTokenUseCase>(GetUserFcmTokenUseCaseImpl(Get.find()));
    Get.put<GetPartnerFcmTokenUseCase>(GetPartnerFcmTokenUseCaseImpl(Get.find()));
  }
}
