import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../resources/resources.dart';
import '../../../model/LoveMessageModelV.dart';
import '../../../theme/app_theme.dart';

const backgroundColor = Color(0xffFCF1DE);
const ownerMessageBackgroundColor = Color(0xffFFD9DE);
const messageAvatarSize = 28.0;

class LoveMessageWidget extends StatelessWidget {
  final LoveMessageModelV model;
  final bool isShowPartnerAvatar;

  const LoveMessageWidget({
    super.key,
    required this.model,
    this.isShowPartnerAvatar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: model.isOwner ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!model.isOwner)
            Container(
              height: messageAvatarSize,
              width: messageAvatarSize,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: isShowPartnerAvatar
                  ? CircleAvatar(child: R.pngs.appIcon.image())
                  : Container(),
            ),
          if (!model.isOwner) Gap(AppThemeExt.of.dimen(2)),
          MessageBox(model: model),
        ],
      ),
    );
  }
}

const bouncingAnimationDuration = 300;

class MessageBox extends StatefulWidget {
  const MessageBox({
    super.key,
    required this.model,
  });

  final LoveMessageModelV model;

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox>
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
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _controller.forward();
        Future.delayed(
          const Duration(milliseconds: bouncingAnimationDuration),
          () {
            _controller.reverse();
          },
        );
      },
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.9).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        ),
        child: _buildContainer(context),
      ),
    );
  }

  Widget _buildContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppThemeExt.of.dimen(5)),
        color: widget.model.isOwner
            ? ownerMessageBackgroundColor
            : backgroundColor,
        border: Border.all(
            color: widget.model.isOwner
                ? ownerMessageBackgroundColor
                : AppColors.of.borderColor),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeExt.of.dimen(2),
        vertical: AppThemeExt.of.dimen(2),
      ),
      margin: EdgeInsets.only(top: AppThemeExt.of.dimen(0.5)),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75 -
            // Horizontal padding
            AppThemeExt.of.dimen(4),
      ),
      child: IntrinsicWidth(
        child: Center(
          child: Text(
            widget.model.message,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: AppColors.of.mainTextColor,
                ),
          ),
        ),
      ),
    );
  }
}
