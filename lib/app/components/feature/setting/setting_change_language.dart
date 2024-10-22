import 'package:flutter/material.dart';

import '../../../services/app_locale_service.dart';
import '../../main/dialogs/app_base_dialog.dart';

class SettingChangeLanguage {
  static void execute(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AppDefaultDialog(
        contentWidgets: [
          RadioListTile<Locale>(
            title: const Text('🇺🇸 English'),
            value: enLocale,
            groupValue: AppLocaleService().locale,
            onChanged: onChangeLanguage,
          ),
          RadioListTile<Locale>(
            title: const Text('🇻🇳 Tiếng Việt'),
            value: viLocale,
            groupValue: AppLocaleService().locale,
            onChanged: onChangeLanguage,
          ),
        ],
      ).build(context),
    );
  }

  static void onChangeLanguage(Locale? value) {
    if (value == null) return;
    AppLocaleService().changeLocale(value);
  }
}
