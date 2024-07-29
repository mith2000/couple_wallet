import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../domain/domain.dart';
import '../../../../../../resources/resources.dart';
import '../../../../../../utilities/logs.dart';
import '../../../../../adapters/love_message_adapter.dart';
import '../../../../../components/feature/love/love_message_widget.dart';
import '../../../../../components/main/animations/placeholders.dart';
import '../../../../../models/love_message_modelview.dart';
import '../../../../../services/app_error_handling_service.dart';
import '../../../../../theme/app_theme.dart';
import '../send_love_controller.dart';

part 'list_message_widget.dart';

class ListMessageController extends GetxController {
  final GetUserFcmTokenUseCase getUserFcmTokenUseCase;
  final GetPartnerFcmTokenUseCase getPartnerFcmTokenUseCase;
  final GetChatSessionUseCase getChatSessionUseCase;

  final RxList<LoveMessageModelV> messages = RxList();
  final RxBool isLoadingMessages = false.obs;

  List<String> chatSessionParticipants = [];
  String myFCMToken = "";
  String partnerFCMToken = "";

  ListMessageController({
    required this.getUserFcmTokenUseCase,
    required this.getPartnerFcmTokenUseCase,
    required this.getChatSessionUseCase,
  });

  @override
  void onInit() async {
    super.onInit();
    await getUserFCMToken();
    await getPartnerFCMToken();
    await getChatSession();
  }

  Future<void> getUserFCMToken() async {
    try {
      final response = await getUserFcmTokenUseCase();
      final value = (response.netData as SimpleModel<String?>).value;
      if (value != null && value.isNotEmpty) {
        chatSessionParticipants.add(value);
        myFCMToken = value;
      } else {}
    } on AppException catch (e) {
      Logs.e("getUserFCMToken failed with ${e.toString()}");
      Get.find<AppErrorHandlingService>().showErrorSnackBar(e.message ?? e.errorCode ?? '');
    }
  }

  Future<void> getPartnerFCMToken() async {
    try {
      final response = await getPartnerFcmTokenUseCase();
      final value = (response.netData as SimpleModel<String>).value;
      if (value != null && value.isNotEmpty) {
        chatSessionParticipants.add(value);
        partnerFCMToken = value;
      } else {
        Logs.e("getPartnerFCMToken failed because value was null or empty");
      }
    } on AppException catch (e) {
      Logs.e("getPartnerFCMToken failed with ${e.toString()}");
      Get.find<AppErrorHandlingService>().showErrorSnackBar(e.message ?? e.errorCode ?? '');
    }
  }

  Future<void> getChatSession({bool isRefresh = true}) async {
    if (chatSessionParticipants.length < 2) return;
    if (isRefresh) isLoadingMessages.value = true;
    try {
      final requestParam = ChatQueryParam(participants: chatSessionParticipants);
      final response = await getChatSessionUseCase(request: requestParam);
      final model = response.netData;
      if (model != null) {
        ILoveMessageAdapter loveMessageAdapter = LoveMessageAdapter();
        messages.value = loveMessageAdapter.getListModelView(model, myFCMToken);
      }
    } on AppException catch (e) {
      Logs.e("_getChatSessionUseCase failed with $e");
      Get.find<AppErrorHandlingService>().showErrorSnackBar(e.message ?? e.errorCode ?? '');
    }
    if (isRefresh) isLoadingMessages.value = false;
  }

  void addMessageToListAsOwner(String stringContent) {
    messages.add(
      LoveMessageModelV.me(
        message: stringContent,
        time: DateTime.now(),
      ),
    );
  }

  void onReplyMessage(BuildContext context) {
    Get.find<SendLoveController>().onReplyMessage(context);
  }
}
