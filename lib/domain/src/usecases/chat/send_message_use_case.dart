part of '../base_use_case.dart';

abstract class SendMessageUseCase
    extends BaseUseCase<SendMessageParam, EmptyModel> {}

class SendMessageUseCaseImpl extends SendMessageUseCase {
  late final ChatRepository _repo;

  SendMessageUseCaseImpl(this._repo);

  @override
  Future<AppResultModel<EmptyModel>> execute({SendMessageParam? request}) =>
      _repo.sendMessage(
        participants: request?.participants ?? [],
        request: request?.toJson(),
      );
}
