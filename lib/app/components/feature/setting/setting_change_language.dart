import 'package:flutter/material.dart';

import '../../../services/app_locale_service.dart';
import '../../main/dialogs/app_base_dialog.dart';
import 'interface_setting_action.dart';

class SettingChangeLanguage implements ISettingAction {
  @override
  void execute(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AppDefaultDialog(
        contentWidgets: [
          RadioListTile<Locale>(
            title: const Text('🇺🇸 English'),
            value: enLocale,
            groupValue: AppLocaleService().locale,
            onChanged: (Locale? value) {
              AppLocaleService().changeLocale(value!);
            },
          ),
          RadioListTile<Locale>(
            title: const Text('🇻🇳 Tiếng Việt'),
            value: viLocale,
            groupValue: AppLocaleService().locale,
            onChanged: (Locale? value) {
              AppLocaleService().changeLocale(value!);
            },
          ),
        ],
      ).build(context),
    );
  }
}
