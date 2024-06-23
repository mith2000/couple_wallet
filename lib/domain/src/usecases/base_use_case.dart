import '../../domain.dart';

part 'chat/get_chat_session_use_case.dart';
part 'chat/send_message_use_case.dart';

abstract class BaseUseCase<In extends BaseParam, Out extends BaseModel> {
  Future<AppResultModel<Out>> execute({In? request}) {
    return Future.value(AppResultModel<Out>(netData: null));
  }

  Future<AppListResultModel<Out>> executeList({In? request}) {
    return Future.value(
        AppListResultModel<Out>(netData: null, total: 0, hasMore: false));
  }
}
