import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../../../resources/resources.dart';
import '../../../theme/app_theme.dart';

const backgroundColor = Color(0xffFCF1DE);

class HomeNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTabChange;

  const HomeNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.all(AppThemeExt.of.dimen(4))
            .copyWith(bottom: AppThemeExt.of.dimen(2)),
        child: GNav(
          tabBorderRadius: AppThemeExt.of.dimen(4),
          selectedIndex: selectedIndex,
          onTabChange: onTabChange,
          tabs: buildTabs(context),
        ),
      ),
    );
  }

  List<GButton> buildTabs(BuildContext context) {
    return [
      buildHomeNavTab(
        context: context,
        activeColor: AppColors.of.primaryColor,
        icon: FontAwesomeIcons.solidHeart,
        text: R.strings.home,
      ),
      buildHomeNavTab(
        context: context,
        activeColor: AppColors.of.disableColor,
        icon: FontAwesomeIcons.fileInvoice,
        text: R.strings.record,
      ),
      buildHomeNavTab(
        context: context,
        activeColor: AppColors.of.disableColor,
        icon: FontAwesomeIcons.chartPie,
        text: R.strings.statistic,
      ),
      buildHomeNavTab(
        context: context,
        activeColor: AppColors.of.orangeColor,
        icon: FontAwesomeIcons.gear,
        text: R.strings.setting,
      )
    ];
  }

  GButton buildHomeNavTab({
    required BuildContext context,
    required Color activeColor,
    required IconData icon,
    required String text,
  }) {
    return GButton(
      gap: AppThemeExt.of.dimen(2),
      iconActiveColor: activeColor,
      iconColor: activeColor,
      textColor: AppColors.of.mainTextColor,
      // backgroundColor: activeColor.withOpacity(.2),
      backgroundGradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [activeColor.withOpacity(.2), activeColor.withOpacity(.4)],
      ),
      rippleColor: activeColor.withOpacity(.2),
      hoverColor: activeColor.withOpacity(.2),
      iconSize: AppThemeExt.of.dimen(6),
      padding: EdgeInsets.symmetric(
        horizontal: AppThemeExt.of.dimen(5),
        vertical: AppThemeExt.of.dimen(3),
      ),
      icon: icon,
      text: text,
      textStyle: context.textTheme.labelLarge!.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.of.mainTextColor,
      ),
    );
  }
}
