import 'package:flutter/material.dart';

import '../../uikit/uikit_controller.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      child: Column(
        children: [
          IconButton(
            onPressed: () => UIKitPage.open(),
            icon: const Icon(
              Icons.palette_sharp,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
