import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../../resources/resources.dart';
import '../../../theme/app_theme.dart';

enum AppTextFieldState { normal, enabled, disabled, focused, error }

class SendLoveInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final String fieldName;
  final Function onSubmit;
  final Function(String?) onFieldChange;

  final bool isShowSendButton;
  final bool isSendButtonWaiting;
  final String sendButtonText;

  const SendLoveInput({
    super.key,
    required this.textEditingController,
    required this.fieldName,
    required this.onSubmit,
    required this.onFieldChange,
    required this.isShowSendButton,
    required this.isSendButtonWaiting,
    required this.sendButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      controller: textEditingController,
      name: fieldName,
      style: context.textTheme.bodyLarge!.copyWith(
        color: AppColors.of.mainTextColor,
      ),
      onSubmitted: (_) => onSubmit(),
      onChanged: onFieldChange,
      minLines: 1,
      maxLines: 3,
      maxLength: 160,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppThemeExt.of.dimen(4),
          vertical: AppThemeExt.of.dimen(3),
        ),
        hintText: R.strings.messageHintText.tr,
        hintStyle: context.textTheme.bodyLarge!.copyWith(
          color: AppColors.of.subTextColor,
        ),
        counterText: "",
        border: _inputBorder(context, AppTextFieldState.normal),
        enabledBorder: _inputBorder(context, AppTextFieldState.enabled),
        focusedBorder: _inputBorder(context, AppTextFieldState.focused),
        disabledBorder: _inputBorder(context, AppTextFieldState.disabled),
        errorBorder: _inputBorder(context, AppTextFieldState.error),
        suffixIcon: isShowSendButton ? _buildSendButton() : null,
      ),
    );
  }

  Widget _buildSendButton() {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: isSendButtonWaiting ? null : () => onSubmit(),
      child: Text(sendButtonText),
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
