part of 'shortcut_bottom_sheet_controller.dart';

const modalSheetHeight = 400.0;
const backgroundColor = Color(0xffFCF1DE);

class ShortcutBottomSheetView extends GetView<ShortcutBottomSheetController> {
  const ShortcutBottomSheetView({super.key});

  static openBottomSheet(BuildContext context) {
    if (!Get.isRegistered<ShortcutBottomSheetController>()) {
      Get.put<ShortcutBottomSheetController>(ShortcutBottomSheetController());
    }
    showModalBottomSheet<void>(
      showDragHandle: true,
      context: context,
      builder: (_) => const ShortcutBottomSheetView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: modalSheetHeight,
      color: Theme.of(context).bottomSheetTheme.backgroundColor,
      child: Column(
        children: [
          Text(
            R.strings.selectShortcut.tr,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          _shortcutSetCard(
            context,
            ShortcutSet.male,
            ShortcutPredefined.shortcutContent1st,
          ),
          _shortcutSetCard(
            context,
            ShortcutSet.female,
            ShortcutPredefined.shortcutContent2nd,
          ),
          Gap(AppThemeExt.of.dimen(6)),
        ],
      ),
    );
  }

  Widget _shortcutSetCard(
    BuildContext context,
    ShortcutSet main,
    List<String> shortcutContents,
  ) {
    return Card(
      margin: EdgeInsets.all(AppThemeExt.of.dimen(4)).copyWith(bottom: 0),
      color: backgroundColor,
      surfaceTintColor: backgroundColor,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: AppColors.of.mainTextColor.withOpacity(0.1),
        onTap: () => controller.setShortcutSet(main),
        child: Row(
          children: [
            _cardContent(context, shortcutContents),
            Obx(
              () => Radio<ShortcutSet>(
                value: main,
                groupValue: controller.shortcutSet.value,
                onChanged: controller.setShortcutSet,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardContent(BuildContext context, List<String> shortcutContents) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(AppThemeExt.of.dimen(4)),
        child: Wrap(
          spacing: AppThemeExt.of.dimen(2),
          children: List.generate(
            // Hide the last item as '...'
            shortcutContents.length - 1,
            (int index) {
              return ChoiceChip(
                label: Text(
                  shortcutContents[index],
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: AppColors.of.mainTextColor,
                      ),
                ),
                showCheckmark: false,
                selected: false,
                onSelected: (bool sel) => {},
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColors.of.borderColor),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
