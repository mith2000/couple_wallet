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
            icon: FontAwesomeIcons.link,
            title: R.strings.loverAddress.tr,
            body: R.strings.loverAddressSubtitle.tr,
            onTap: () {
              _dialogLoveAddress(context);
            },
          ),
          SettingRow(
            icon: AppLocaleService().locale == enLocale
                ? FontAwesomeIcons.earthAmericas
                : FontAwesomeIcons.earthAsia,
            title: R.strings.switchLanguage.tr,
            body: R.strings.chooseLanguagePrefer.tr,
            onTap: () {
              _dialogChangeLanguage(context);
            },
          ),
        ],
      ),
    );
  }

  void _dialogLoveAddress(BuildContext context) {
    AppDefaultDialog().show(
      context,
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
              icon: const FaIcon(
                FontAwesomeIcons.shareNodes,
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
                onPressed: () => controller.onLockPartnerInput(context),
                icon: FaIcon(
                  controller.isPartnerLocked.isTrue
                      ? FontAwesomeIcons.lock
                      : FontAwesomeIcons.lockOpen,
                ),
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
    );
  }

  void _dialogChangeLanguage(BuildContext context) {
    AppDefaultDialog().show(
      context,
      contentWidgets: [
        RadioListTile<Locale>(
          title: const Text('🇺🇸 English'),
          value: enLocale,
          groupValue: AppLocaleService().locale,
          onChanged: (Locale? value) {
            AppLocaleService().changeLocale(value!);
          },
        ),
        RadioListTile<Locale>(
          title: const Text('🇻🇳 Tiếng Việt'),
          value: viLocale,
          groupValue: AppLocaleService().locale,
          onChanged: (Locale? value) {
            AppLocaleService().changeLocale(value!);
          },
        ),
      ],
    );
  }
}
