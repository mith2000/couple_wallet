import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/app_theme.dart';

enum AppTextFieldState { normal, enabled, disabled, focused, error }

class FCMTokenInput extends StatelessWidget {
  final TextEditingController textEditingController;

  const FCMTokenInput({
    super.key,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      style: context.textTheme.bodyMedium!.copyWith(
        color: AppColors.of.mainTextColor.withOpacity(0.38),
      ),
      minLines: 1,
      maxLines: 3,
      enabled: false,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppThemeExt.of.dimen(6),
          vertical: AppThemeExt.of.dimen(4),
        ),
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
