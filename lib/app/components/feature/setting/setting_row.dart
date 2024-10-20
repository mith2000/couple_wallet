import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/app_icons.dart';
import '../../../theme/app_theme.dart';

const settingIconAreaSize = 56.0;
const settingIconBackgroundSize = 40.0;
const backgroundDimColor = Color(0xffF7EAD4);
const divider = Divider(color: backgroundDimColor, height: 1);

class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return onTap == null
        ? content(context)
        : InkWell(
            onTap: () => onTap?.call(),
            child: content(context),
          );
  }

  Widget content(BuildContext context) {
    return Row(
      children: [
        Gap(AppThemeExt.of.dimen(2)),
        settingIcon(),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              divider,
              Gap(AppThemeExt.of.dimen(2)),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  settingTextInfo(context),
                  Gap(AppThemeExt.of.dimen(2)),
                  if (onTap != null) AppIconsWidget.chevronRight,
                ],
              ),
              Gap(AppThemeExt.of.dimen(2)),
              divider,
            ],
          ),
        ),
        Gap(AppThemeExt.of.dimen(4)),
      ],
    );
  }

  Widget settingIcon() {
    return SizedBox(
      width: settingIconAreaSize,
      child: Center(
        child: Container(
          width: settingIconBackgroundSize,
          height: settingIconBackgroundSize,
          decoration: BoxDecoration(
            color: backgroundDimColor,
            borderRadius: AppThemeExt.of.borderRadius(2),
          ),
          child: Icon(icon),
        ),
      ),
    );
  }

  Widget settingTextInfo(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.of.mainTextColor,
                ),
          ),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.of.mainTextColor,
                ),
          ),
        ],
      ),
    );
  }
}
