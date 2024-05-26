import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class HighlightHeadlineText extends StatelessWidget {
  const HighlightHeadlineText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final firstCharacter = text[0];
    final remainingText = text.substring(1);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          firstCharacter,
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: AppColors.of.primaryColor,
                fontWeight: FontWeight.w500,
              ),
        ),
        Text(
          remainingText,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: AppColors.of.mainTextColor,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
