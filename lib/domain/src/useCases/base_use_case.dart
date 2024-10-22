import '../../../utilities/date_time_util.dart';
import '../../../utilities/logs.dart';
import '../../domain.dart';

part 'auth/get_user_id_use_case.dart';
part 'auth/get_user_info_use_case.dart';
part 'auth/register_user_use_case.dart';
part 'auth/save_user_id_use_case.dart';
part 'chat/get_chat_session_use_case.dart';
part 'chat/get_partner_fcm_token_use_case.dart';
part 'chat/get_user_fcm_token_use_case.dart';
part 'chat/save_partner_fcm_token_use_case.dart';
part 'chat/send_message_use_case.dart';
part 'loveInfo/get_love_info_use_case.dart';

abstract class BaseUseCase<In extends BaseParam, Out extends BaseModel> {
  Future<AppResultModel<Out>> call({In? request}) {
    return Future.value(AppResultModel<Out>(netData: null));
  }

  Future<AppListResultModel<Out>> toList({In? request}) {
    return Future.value(
        AppListResultModel<Out>(netData: null, total: 0, hasMore: false));
  }
}
