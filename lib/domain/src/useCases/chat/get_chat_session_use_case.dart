part of '../base_use_case.dart';

abstract class GetChatSessionUseCase
    extends BaseUseCase<ChatQueryParam, ChatModel> {}

class GetChatSessionUseCaseImpl extends GetChatSessionUseCase {
  late final ChatRepository _repo;

  GetChatSessionUseCaseImpl(this._repo);

  @override
  Future<AppResultModel<ChatModel>> call({ChatQueryParam? request}) =>
      _repo.getChatSession(participants: request?.participants ?? []);
}
