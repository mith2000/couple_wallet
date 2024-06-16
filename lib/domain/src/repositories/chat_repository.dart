part of 'base_repository.dart';

abstract class ChatRepository {
  Future<AppResultModel<ChatModel>> getChatSession({
    required List<String> participants,
  });

  Future<AppResultModel<EmptyModel>> sendMessage({
    required List<String> participants,
    required Map<String, dynamic>? request,
  });
}
