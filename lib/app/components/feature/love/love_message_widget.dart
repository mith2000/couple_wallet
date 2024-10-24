import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../domain/domain.dart';
import '../../../../resources/resources.dart';
import '../../../models/love_message_modelview.dart';
import '../../../services/app_system_feedback.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_theme.dart';

const backgroundColor = Color(0xffFCF1DE);
const ownerMessageBackgroundColor = Color(0xffFFD9DE);
const messageAvatarSize = 28.0;
const messageBoxWidthRatio = 0.75;

class LoveMessageWidget extends StatelessWidget {
  final LoveMessageModelV model;
  final bool isShowPartnerAvatar;
  final Function? onReply;

  /// For render most recent notice
  final bool isFirstOfList;

  /// For render date notice
  final LoveMessageModelV? previousModel;

  const LoveMessageWidget({
    super.key,
    required this.model,
    this.isShowPartnerAvatar = false,
    this.onReply,
    this.isFirstOfList = false,
    this.previousModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...buildMostRecentNotice(context),
        ...buildDateNotice(context),
        Align(
          alignment:
              model.isOwner ? Alignment.centerRight : Alignment.centerLeft,
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
              MessageBox(model: model, onReply: onReply),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> buildMostRecentNotice(BuildContext context) {
    if (isFirstOfList) {
      return [
        Gap(AppThemeExt.of.dimen(2)),
        Text(
          R.strings.mostRecentLoveMessage.tr,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ];
    }
    return [];
  }

  List<Widget> buildDateNotice(BuildContext context) {
    if (previousModel != null) {
      final dateDisplayService = Get.find<DateDisplayService>();
      if (!dateDisplayService.isDisplayDate(previousModel!.time, model.time)) {
        return [];
      }
    }
    return [
      Gap(AppThemeExt.of.dimen(2)),
      Text(
        model.getTimeDisplay(),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      Gap(AppThemeExt.of.dimen(2)),
    ];
  }
}

const bouncingAnimationDuration = 300;

class MessageBox extends StatefulWidget {
  const MessageBox({
    super.key,
    required this.model,
    this.onReply,
  });

  final LoveMessageModelV model;
  final Function? onReply;

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
    return MenuAnchor(
      builder: (context, controller, child) {
        return GestureDetector(
          onLongPress: () async {
            await AppSystemFeedback.lightFeedback();
            _controller.forward();
            Future.delayed(
              const Duration(milliseconds: bouncingAnimationDuration),
              () {
                _controller.reverse();
                controller.open();
              },
            );
          },
          child: ScaleTransition(
            scale: Tween(begin: 1.0, end: 0.8).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            ),
            child: _buildContainer(context),
          ),
        );
      },
      alignmentOffset: Offset(0, AppThemeExt.of.dimen(1)),
      menuChildren: [..._buildMenuChildren()],
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
        maxWidth: MediaQuery.of(context).size.width * messageBoxWidthRatio -
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

  List<Widget> _buildMenuChildren() {
    return [
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppThemeExt.of.dimen(3),
        ).copyWith(bottom: AppThemeExt.of.dimen(1)),
        child: Text(
          widget.model.getTimeDisplay(),
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
      MenuItemButton(
        trailingIcon: AppIconsWidget.reply,
        child: Text(R.strings.reply.tr),
        onPressed: () {
          widget.onReply?.call();
        },
      ),
      MenuItemButton(
        trailingIcon: AppIconsWidget.copy,
        child: Text(R.strings.copy.tr),
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: widget.model.message));
        },
      ),
    ];
  }
}
