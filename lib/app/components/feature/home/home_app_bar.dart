import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../resources/resources.dart';
import '../../../theme/app_theme.dart';
import 'home_heart_icon.dart';

const backgroundColor = Color(0xffFCF1DE);
const backgroundDimColor = Color(0xffF7EAD4);
const appBarHeight = 200.0;
const appBarBottomHeight = 24.0;
const appBarBottomHandlerHeight = 16.0;
const appBarBottomHandlerWidth = 80.0;
const appBarBottomHandlerLogoSize = 44.0;
const titleBottomSpacing = 52.0;
const avatarSize = 72.0;
const heartSize = 88.0;

class HomeAppBar extends StatelessWidget {
  final List<Widget>? actions;
  final String loveCount;

  const HomeAppBar({
    super.key,
    required this.actions,
    required this.loveCount,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: backgroundDimColor,
      floating: true,
      expandedHeight: appBarHeight,
      actions: actions,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: backgroundDimColor,
        ),
        title: _spaceWidget(context),
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: titleBottomSpacing),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(appBarBottomHeight),
        child: _bottomDragHandler(),
      ),
    );
  }

  Widget _bottomDragHandler() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: double.infinity,
          height: appBarBottomHeight,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppThemeExt.of.dimen(10)),
              topRight: Radius.circular(AppThemeExt.of.dimen(10)),
            ),
          ),
        ),
        Container(
          width: appBarBottomHandlerWidth,
          height: appBarBottomHandlerHeight,
          transform: Matrix4.translationValues(0, AppThemeExt.of.dimen(-2), 0),
          decoration: BoxDecoration(
            color: backgroundDimColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppThemeExt.of.dimen(10)),
              bottomRight: Radius.circular(AppThemeExt.of.dimen(10)),
            ),
          ),
        ),
        Container(
          transform: Matrix4.translationValues(0, AppThemeExt.of.dimen(-2), 0),
          child: R.pngs.appIcon.image(
            height: appBarBottomHandlerLogoSize,
            width: appBarBottomHandlerLogoSize,
          ),
        ),
      ],
    );
  }

  Widget _spaceWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _avatar(),
        Stack(
          alignment: Alignment.center,
          children: [
            const HeartAnimation(size: heartSize),
            Positioned(
              top: heartSize * 1 / 3 + 2,
              child: Text(
                loveCount,
                style: context.textTheme.bodyMedium!.copyWith(
                  color: backgroundColor,
                ),
              ),
            )
          ],
        ),
        _avatar(),
      ],
    );
  }

  Widget _avatar() {
    return Container(
      height: avatarSize,
      width: avatarSize,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: CircleAvatar(child: R.pngs.appIcon.image()),
    );
  }
}
