import '../../../domain/domain.dart';
import '../raws/base_raw.dart';
import '../sources/firestore/base_firestore_data_source.dart';

class ChatRepositoryImpl extends ChatRepository {
  late final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<AppResultModel<ChatModel>> getChatSession({
    required List<String> participants,
  }) async {
    try {
      final AppResultRaw<ChatRaw> remoteData =
          await _remoteDataSource.getChatSession(
        participants: participants,
      );

      return remoteData.raw2Model();
    } on NetworkException catch (_) {
      rethrow;
    }
  }

  @override
  Future<AppResultModel<EmptyModel>> sendMessage({
    required List<String> participants,
    required Map<String, dynamic>? request,
  }) async {
    try {
      final AppResultRaw<EmptyRaw> remoteData =
          await _remoteDataSource.sendMessage(
        participants: participants,
        request: request,
      );

      return remoteData.raw2Model();
    } on NetworkException catch (_) {
      rethrow;
    }
  }
}
