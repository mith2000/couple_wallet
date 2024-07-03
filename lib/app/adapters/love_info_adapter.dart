import '../../domain/domain.dart';
import '../models/love_info_modelview.dart';

class LoveInfoAdapter {
  static LoveInfoModelView getModelView(LoveInfoModel model) {
    return LoveInfoModelView(totalLoveDays: model.totalLoveDays);
  }
}
