import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../resources/resources.dart';
import '../../../theme/app_theme.dart';

const bouncingAnimationDuration = 300;

enum AppTextFieldState { normal, enabled, disabled, focused, error }

class SendLoveInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final Function onSubmit;
  final bool isShowSendButton;
  final bool isSendButtonWaiting;
  final String sendButtonText;

  const SendLoveInput({
    super.key,
    required this.textEditingController,
    required this.focusNode,
    required this.onSubmit,
    required this.isShowSendButton,
    required this.isSendButtonWaiting,
    required this.sendButtonText,
  });

  @override
  State<SendLoveInput> createState() => _SendLoveInputState();
}

class _SendLoveInputState extends State<SendLoveInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: bouncingAnimationDuration),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        GestureDetector(
          onTapDown: (TapDownDetails details) {
            // If focusing the text field, don't animate
            if (widget.focusNode.hasFocus) return;
            _controller.forward();
          },
          onTapUp: (TapUpDetails details) {
            _onReleaseTap(context);
          },
          onTapCancel: () {
            _onReleaseTap(context);
          },
          child: ScaleTransition(
            scale: Tween(begin: 1.0, end: 0.9).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            ),
            child: TextField(
              controller: widget.textEditingController,
              focusNode: widget.focusNode,
              style: context.textTheme.bodyLarge!.copyWith(
                color: AppColors.of.mainTextColor,
              ),
              minLines: 1,
              maxLines: 3,
              maxLength: 160,
              textCapitalization: TextCapitalization.sentences,
              magnifierConfiguration: TextMagnifierConfiguration.disabled,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(
                  left: AppThemeExt.of.dimen(4),
                  right: AppThemeExt.of.dimen(12),
                  top: AppThemeExt.of.dimen(3),
                  bottom: AppThemeExt.of.dimen(3),
                ),
                hintText: R.strings.messageHintText.tr,
                hintStyle: context.textTheme.bodyLarge!.copyWith(
                  color: AppColors.of.subTextColor,
                ),
                counterText: "",
                border: _inputBorder(context, AppTextFieldState.normal),
                enabledBorder: _inputBorder(context, AppTextFieldState.enabled),
                focusedBorder: _inputBorder(context, AppTextFieldState.focused),
                disabledBorder:
                    _inputBorder(context, AppTextFieldState.disabled),
                errorBorder: _inputBorder(context, AppTextFieldState.error),
              ),
            ),
          ),
        ),
        widget.isShowSendButton ? _buildSendButton() : Container(),
      ],
    );
  }

  void _onReleaseTap(BuildContext context) {
    _controller.reverse();
    // The Future.delayed function is used to add a small delay before the TextField gains focus, ensuring that the animation has time to complete before the keyboard appears
    Future.delayed(
      const Duration(milliseconds: bouncingAnimationDuration),
      () {
        FocusScope.of(context).requestFocus(widget.focusNode);
      },
    );
  }

  Widget _buildSendButton() {
    return InkWell(
      onTap: widget.isSendButtonWaiting ? null : () => widget.onSubmit(),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: AppThemeExt.of.dimen(6)),
        child: IntrinsicWidth(
          child: Center(
            child: Text(
              widget.sendButtonText,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: widget.isSendButtonWaiting
                        ? AppColors.of.disableColor
                        : AppColors.of.primaryColor,
                  ),
            ),
          ),
        ),
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
      borderRadius: BorderRadius.circular(AppThemeExt.of.dimen(6)),
      borderSide: BorderSide(color: borderColor),
      gapPadding: 0,
    );
  }
}
