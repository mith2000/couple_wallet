part of 'setting_controller.dart';

class SettingScreen extends GetView<SettingController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
        const HomeAppBar(),
      ],
      body: ListView(
        children: [
          if (kDebugMode)
            Row(
              children: [
                Expanded(child: Container()),
                IconButton(
                  onPressed: () => UIKitPage.open(),
                  icon: AppIconsWidget.palette,
                ),
              ],
            ),
          ...setting(context),
          Gap(AppThemeExt.of.dimen(3)),
          ...aboutUs(context),
        ],
      ),
    );
  }

  List<Widget> setting(BuildContext context) {
    return [
      Padding(
        padding: EdgeInsets.only(left: AppThemeExt.of.dimen(4)),
        child: HighlightHeadlineText(text: R.strings.setting.tr),
      ),
      Gap(AppThemeExt.of.dimen(3)),
      SettingRow(
        icon: AppIcons.link,
        title: R.strings.loverAddress.tr,
        body: R.strings.loverAddressSubtitle.tr,
        onTap: () => _dialogLoveAddress(context),
      ),
      SettingRow(
        icon: AppLocaleService().locale == enLocale
            ? AppIcons.earthAmericas
            : AppIcons.earthAsia,
        title: R.strings.switchLanguage.tr,
        body: R.strings.chooseLanguagePrefer.tr,
        onTap: () => SettingChangeLanguage.execute(context),
      ),
    ];
  }

  List<Widget> aboutUs(BuildContext context) {
    return [
      Padding(
        padding: EdgeInsets.only(left: AppThemeExt.of.dimen(4)),
        child: HighlightHeadlineText(text: R.strings.aboutUs.tr),
      ),
      Gap(AppThemeExt.of.dimen(3)),
      Obx(
        () => SettingRow(
          icon: AppIcons.dev,
          title: R.strings.appInfo.tr,
          body:
              "${R.strings.version.tr}: ${controller.appVersion.value} build ${controller.appBuildNumber.value}",
        ),
      ),
    ];
  }

  void _dialogLoveAddress(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AppDefaultDialog(
        onPreBuild: () {
          // To reflect the right value when the dialog is opened
          controller.loadPartnerAddress();
          controller.onOpenLoveAddressDialog();
        },
        contentWidgets: [
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
                onPressed: controller.onShareUserAddress,
                icon: AppIconsWidget.shareNodes,
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
                  onPressed: () => controller.onLockPartnerInput(context),
                  icon: controller.isPartnerLocked.isTrue
                      ? AppIconsWidget.lock
                      : AppIconsWidget.lockOpen,
                ),
              ),
            ],
          ),
          Obx(
            () => controller.isShowQuickPaste.isTrue
                ? TextButton(
                    onPressed: controller.onPasteToPartnerAddress,
                    child: Text(R.strings.quickPasteHere.tr),
                  )
                : Container(),
          ),
        ],
        onPrimaryPressed: () => controller.onCloseLoveAddressDialog(context),
      ).build(context),
    );
  }
}
