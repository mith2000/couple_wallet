part of 'base_param.dart';

class AppListParam extends BaseParam {
  int page;
  int limit;

  AppListParam({required this.page, this.limit = 30});

  Map<String, dynamic> toJson() => {
        'page': page.toString(),
        'limit': limit.toString(),
      };
}
