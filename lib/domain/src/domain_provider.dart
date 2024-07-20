import 'package:get/get.dart';

import '../domain.dart';

class DomainProvider {
  static Future<void> inject() async {
    Get.lazyPut<GetChatSessionUseCase>(() => GetChatSessionUseCaseImpl(Get.find()));
    Get.lazyPut<SendMessageUseCase>(() => SendMessageUseCaseImpl(Get.find()));
    Get.lazyPut<GetLoveInfoUseCase>(() => GetLoveInfoUseCaseImpl());
    Get.lazyPut<GetUserFcmTokenUseCase>(() => GetUserFcmTokenUseCaseImpl(Get.find()));
    Get.lazyPut<GetPartnerFcmTokenUseCase>(() => GetPartnerFcmTokenUseCaseImpl(Get.find()));
    Get.lazyPut<SavePartnerFcmTokenUseCase>(() => SavePartnerFcmTokenUseCaseImpl(Get.find()));
  }
}
