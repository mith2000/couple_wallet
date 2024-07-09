part of '../base_use_case.dart';

abstract class SendMessageUseCase extends BaseUseCase<SendMessageParam, EmptyModel> {}

class SendMessageUseCaseImpl extends SendMessageUseCase {
  late final ChatRepository _repo;

  SendMessageUseCaseImpl(this._repo);

  @override
  Future<AppResultModel<EmptyModel>> execute({SendMessageParam? request}) {
    if ((request?.participants.length ?? 0) < 2) {
      throw LocalException(
        code: ErrorCode.code400,
        message: 'Lack of participants',
        errorCode: ErrorCode.lackOfParticipantsError,
      );
    }
    return _repo.sendMessage(
      participants: request?.participants ?? [],
      request: request?.toJson(),
    );
  }
}
