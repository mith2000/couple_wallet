part of 'setting_controller.dart';

class SettingScreen extends GetView<SettingController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (kDebugMode)
          Row(
            children: [
              Expanded(child: Container()),
              IconButton(
                onPressed: () => UIKitPage.open(),
                icon: const Icon(Icons.palette_sharp),
              ),
            ],
          ),
        Padding(
          padding: EdgeInsets.only(left: AppThemeExt.of.dimen(4)),
          child: HighlightHeadlineText(text: R.strings.setting),
        ),
        Gap(AppThemeExt.of.dimen(3)),
        SettingRow(
          icon: Icons.link_rounded,
          title: R.strings.loverAddress.tr,
          body: R.strings.loverAddressSubtitle.tr,
          onTap: () {
            _dialogLoveAddress(context);
          },
        ),
      ],
    );
  }

  void _dialogLoveAddress(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(AppThemeExt.of.dimen(2)),
            Row(
              children: [
                Expanded(
                  child: FCMTokenInput(
                    textEditingController: controller.yourAddressTextEC,
                    isYour: true,
                    isEnabled: false,
                  ),
                ),
                IconButton(
                  onPressed: controller.onCopyFCMToken,
                  icon: const Icon(
                    Icons.share_rounded,
                  ),
                ),
              ],
            ),
            Gap(AppThemeExt.of.dimen(4)),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => FCMTokenInput(
                      textEditingController: controller.partnerAddressTextEC,
                      isYour: false,
                      isEnabled: !controller.isPartnerLocked.value,
                    ),
                  ),
                ),
                Obx(
                  () => IconButton(
                    onPressed: () => controller.onLockFCMToken(context),
                    icon: Icon(
                      controller.isPartnerLocked.isTrue
                          ? Icons.lock_outline_rounded
                          : Icons.lock_open_rounded,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          FilledButton(
            child: const Text('Okay'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
