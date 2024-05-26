part of 'setting_controller.dart';

class SettingScreen extends GetView<SettingController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppThemeExt.of.dimen(4)).copyWith(top: 0),
      child: ListView(
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
          HighlightHeadlineText(text: R.strings.setting),
          Gap(AppThemeExt.of.dimen(4)),
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
    );
  }
}
