class DataProvider {
  static Future<void> inject() async {
    _DataSourceProvider.inject();
    _RepoProvider.inject();
  }
}

class _DataSourceProvider {
  static void inject() {}
}

class _RepoProvider {
  static void inject() {}
}
