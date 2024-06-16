import '../../../domain/domain.dart';

part 'app_result_raw.dart';

abstract class BaseRaw<BM extends BaseModel> {
  BM raw2Model();
}

class EmptyRaw extends BaseRaw<EmptyModel> {
  @override
  EmptyModel raw2Model() {
    return EmptyModel();
  }
}
