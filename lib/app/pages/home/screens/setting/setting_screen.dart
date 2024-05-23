part of 'setting_controller.dart';

class SettingScreen extends GetView<SettingController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppThemeExt.of.dimen(4)),
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
                  textEditingController: controller.textEditingController,
                ),
              ),
              IconButton(
                onPressed: controller.onCopyFCMToken,
                icon: const Icon(
                  Icons.content_copy_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
