import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../data/src/keys/app_key.dart';
import '../../../../../../data/src/services/app_shared_pref.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../../utilities/logs.dart';
import '../../../../../components/feature/love/love_message_widget.dart';
import '../../../../../models/love_message_modelview.dart';
import '../send_love_controller.dart';

part 'list_message_widget.dart';

class ListMessageController extends GetxController {
  final AppSharedPref _pref = Get.find();
  final GetChatSessionUseCase _getChatSessionUseCase = Get.find();
  final SendMessageUseCase _sendMessageUseCase = Get.find();

  final RxList<LoveMessageModelV> messages = RxList();
  List<String> chatSessionParticipants = [];
  String myFCMToken = "";

  @override
  void onInit() async {
    super.onInit();
    await collectChatParticipants();
    await getChatSession();
  }

  Future<void> collectChatParticipants() async {
    String? userFCMToken = await FirebaseMessaging.instance.getToken();
    String partnerAddress = _pref.getString(AppPrefKey.partnerAddress, '');
    if (userFCMToken != null && userFCMToken.isNotEmpty) {
      chatSessionParticipants.add(userFCMToken);
      myFCMToken = userFCMToken;
    } else {
      // TODO Inform need permission
    }
    if (partnerAddress.isNotEmpty) {
      chatSessionParticipants.add(partnerAddress);
    } else {
      // TODO Inform lack of partner
    }
  }

  Future<void> getChatSession() async {
    if (chatSessionParticipants.length < 2) return;
    try {
      final response = await _getChatSessionUseCase.execute(
          request: ChatQueryParam(participants: chatSessionParticipants));
      final chatModel = response.netData;
      if (chatModel != null) {
        messages.value = LoveMessageModelV.fromChatModel(chatModel, myFCMToken);
      }
    } on AppException catch (e) {
      Logs.e("_getChatSessionUseCase failed with $e");
    }
  }

  Future<void> sendMessage(String content) async {
    if (chatSessionParticipants.length < 2) return;
    try {
      await _sendMessageUseCase.execute(
        request: SendMessageParam(
          participants: chatSessionParticipants,
          sender: myFCMToken,
          content: content,
          timestamp: DateTime.now(),
        ),
      );
    } on AppException catch (e) {
      Logs.e("_sendMessageUseCase failed with $e");
    }
  }

  void addMessage(String stringContent) {
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
