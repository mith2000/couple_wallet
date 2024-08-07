import 'package:couple_wallet/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../data/src/keys/app_key.dart';
import '../../../../../data/src/services/app_shared_pref.dart';
import '../../../../../resources/resources.dart';

part 'shortcut_bottom_sheet_view.dart';

class ShortcutBottomSheetController extends GetxController {
  final AppSharedPref pref;

  final Rxn<ShortcutSet> shortcutSet = Rxn<ShortcutSet>(ShortcutSet.male);
  final RxList<String> shortcutContents = RxList<String>(ShortcutPredefined.shortcutContent1st);

  ShortcutBottomSheetController({required this.pref});

  @override
  void onInit() async {
    await loadShortcutSetName();
    super.onInit();
  }

  Future<void> loadShortcutSetName() async {
    String shortcutSetName = pref.getString(AppPrefKey.shortcutSetName, '');
    if (shortcutSetName.isNotEmpty) {
      if (shortcutSetName == ShortcutSet.male.name) {
        setShortcutSet(ShortcutSet.male);
      } else {
        setShortcutSet(ShortcutSet.female);
      }
    }
  }

  Future<void> setShortcutSet(ShortcutSet? shortcutSet) async {
    this.shortcutSet.value = shortcutSet;
    if (this.shortcutSet.value == ShortcutSet.male) {
      shortcutContents.value = ShortcutPredefined.shortcutContent1st;
      await saveShortcutSetName(ShortcutSet.male.name);
    } else {
      shortcutContents.value = ShortcutPredefined.shortcutContent2nd;
      await saveShortcutSetName(ShortcutSet.female.name);
    }
  }

  Future<void> saveShortcutSetName(String shortcutSetName) async {
    await pref.setString(AppPrefKey.shortcutSetName, shortcutSetName);
  }
}

enum ShortcutSet {
  male('male'),
  female('female');

  final String name;

  const ShortcutSet(this.name);
}

class ShortcutPredefined {
  static final List<String> shortcutContent1st = [
    R.strings.maleShortcut1.tr,
    R.strings.maleShortcut2.tr,
    R.strings.maleShortcut3.tr,
    R.strings.maleShortcut4.tr,
    // Last item for open bottom sheet
    '...',
  ];
  static final List<String> shortcutContent2nd = [
    R.strings.femaleShortcut1.tr,
    R.strings.femaleShortcut2.tr,
    R.strings.femaleShortcut3.tr,
    R.strings.femaleShortcut4.tr,
    // Last item for open bottom sheet
    '...',
  ];
}
