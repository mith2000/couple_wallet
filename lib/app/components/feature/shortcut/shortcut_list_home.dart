import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../theme/app_theme.dart';

class ShortcutListHome extends StatelessWidget {
  const ShortcutListHome({
    super.key,
    required this.shortcutContents,
    required this.shortcutSelectedIndex,
    required this.onSelected,
  });

  final List<String> shortcutContents;
  final int? shortcutSelectedIndex;
  final Function onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(AppThemeExt.of.dimen(1)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              shortcutContents.length,
              (int index) {
                return Row(
                  children: [
                    if (index != 0) Gap(AppThemeExt.of.dimen(2)),
                    ChoiceChip(
                      label: Text(
                        shortcutContents[index],
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: AppColors.of.mainTextColor,
                            ),
                      ),
                      showCheckmark: false,
                      selected: shortcutSelectedIndex == index,
                      onSelected: (bool sel) => onSelected(context, sel, index),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: shortcutSelectedIndex == index
                              ? Theme.of(context).primaryColor
                              : AppColors.of.borderColor,
                        ),
                        borderRadius: BorderRadius.circular(AppThemeExt.of.dimen(5)),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
