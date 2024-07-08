import '../../domain/domain.dart';
import '../models/love_info_modelview.dart';

abstract class ILoveInfoAdapter {
  LoveInfoModelView getModelView(LoveInfoModel model);
}

class LoveInfoAdapter implements ILoveInfoAdapter {
  @override
  LoveInfoModelView getModelView(LoveInfoModel model) {
    return LoveInfoModelView(totalLoveDays: model.totalLoveDays);
  }
}
