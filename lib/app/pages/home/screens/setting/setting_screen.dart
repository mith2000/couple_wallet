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
          Text("Setting", style: Theme.of(context).textTheme.displaySmall),
          Gap(AppThemeExt.of.dimen(4)),
          Row(
            children: [
              Expanded(
                child: FCMTokenInput(
                  textEditingController: controller.yourAddressTextEC,
                  isYour: true,
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
                child: FCMTokenInput(
                  textEditingController: controller.partnerAddressTextEC,
                  isYour: false,
                ),
              ),
              IconButton(
                onPressed: controller.onSaveFCMToken,
                icon: const Icon(
                  Icons.save_alt_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
