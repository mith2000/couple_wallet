import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../resources/resources.dart';
import '../../../theme/app_theme.dart';

enum AppTextFieldState { normal, enabled, disabled, focused, error }

class FCMTokenInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isYour;
  final bool isEnabled;

  const FCMTokenInput({
    super.key,
    required this.textEditingController,
    required this.isYour,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      style: context.textTheme.bodyLarge!.copyWith(
        color: AppColors.of.mainTextColor.withOpacity(isEnabled ? 1 : 0.38),
      ),
      maxLines: 1,
      enabled: isEnabled,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppThemeExt.of.dimen(4),
          vertical: AppThemeExt.of.dimen(3),
        ),
        labelText: isYour
            ? R.strings.yourDigitalAddress.tr
            : R.strings.yourPartnerAddress.tr,
        border: _inputBorder(context, AppTextFieldState.normal),
        enabledBorder: _inputBorder(context, AppTextFieldState.enabled),
        focusedBorder: _inputBorder(context, AppTextFieldState.focused),
        disabledBorder: _inputBorder(context, AppTextFieldState.disabled),
        errorBorder: _inputBorder(context, AppTextFieldState.error),
      ),
    );
  }

  InputBorder _inputBorder(
    BuildContext context,
    AppTextFieldState appTextFieldState,
  ) {
    Color borderColor = AppColors.of.grayColor[5] ?? AppColors.of.grayColor;

    switch (appTextFieldState) {
      case AppTextFieldState.normal:
      case AppTextFieldState.enabled:
      case AppTextFieldState.focused:
        break;
      case AppTextFieldState.disabled:
        borderColor = AppColors.of.disableColor;
        break;
      case AppTextFieldState.error:
        borderColor = AppColors.of.redColor;
        break;
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppThemeExt.of.dimen(10)),
      borderSide: BorderSide(color: borderColor),
      gapPadding: 0,
    );
  }
}
