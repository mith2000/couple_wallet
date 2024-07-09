import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../domain/domain.dart';
import '../../../../../../utilities/logs.dart';
import '../../../../../adapters/love_message_adapter.dart';
import '../../../../../components/feature/love/love_message_widget.dart';
import '../../../../../models/love_message_modelview.dart';
import '../../../../../services/app_error_handling_service.dart';
import '../send_love_controller.dart';

part 'list_message_widget.dart';

class ListMessageController extends GetxController {
  final GetUserFcmTokenUseCase _getUserFcmTokenUseCase = Get.find();
  final GetPartnerFcmTokenUseCase _getPartnerFcmTokenUseCase = Get.find();
  final GetChatSessionUseCase _getChatSessionUseCase = Get.find();

  final RxList<LoveMessageModelV> messages = RxList();
  List<String> chatSessionParticipants = [];
  String myFCMToken = "";
  String partnerFCMToken = "";

  @override
  void onInit() async {
    super.onInit();
    await getUserFCMToken();
    await getPartnerFCMToken();
    await getChatSession();
  }

  Future<void> getUserFCMToken() async {
    final response = await _getUserFcmTokenUseCase.execute();
    try {
      final value = (response.netData as SimpleModel<String?>).value;
      if (value != null && value.isNotEmpty) {
        chatSessionParticipants.add(value);
        myFCMToken = value;
      } else {
      }
    } on AppException catch (e) {
      Logs.e("getUserFCMToken failed with ${e.toString()}");
      Get.find<AppErrorHandlingService>().showErrorSnackBar(e.message ?? e.errorCode ?? '');
    }
  }

  Future<void> getPartnerFCMToken() async {
    final response = await _getPartnerFcmTokenUseCase.execute();
    try {
      final value = (response.netData as SimpleModel<String>).value;
      if (value != null && value.isNotEmpty) {
        chatSessionParticipants.add(value);
        partnerFCMToken = value;
      } else {
      }
    } on AppException catch (e) {
      Logs.e("getUserFCMToken failed with ${e.toString()}");
      Get.find<AppErrorHandlingService>().showErrorSnackBar(e.message ?? e.errorCode ?? '');
    }
  }

  Future<void> getChatSession() async {
    if (chatSessionParticipants.length < 2) return;
    try {
      final response = await _getChatSessionUseCase.execute(
          request: ChatQueryParam(participants: chatSessionParticipants));
      final model = response.netData;
      if (model != null) {
        ILoveMessageAdapter loveMessageAdapter = LoveMessageAdapter();
        messages.value = loveMessageAdapter.getListModelView(model, myFCMToken);
      }
    } on AppException catch (e) {
      Logs.e("_getChatSessionUseCase failed with $e");
      Get.find<AppErrorHandlingService>().showErrorSnackBar(e.message ?? e.errorCode ?? '');
    }
  }

  void addMessageToListAsOwner(String stringContent) {
    messages.add(
      LoveMessageModelV(
        message: stringContent,
        isOwner: true,
        time: DateTime.now(),
      ),
    );
  }

  void onReplyMessage(BuildContext context) {
    Get.find<SendLoveController>().onReplyMessage(context);
  }
}
