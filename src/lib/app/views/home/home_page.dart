import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:src/core/themes/styles.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This is HomePage'.tr,
              style: AppTextStyle.title(context),
            ),
            GetBuilder<HomeController>(
              id: UpdateHomePage.switchButtonTheme,
              builder: (_) {
                return CupertinoSwitch(
                  value: !_.isLightMode,
                  onChanged: (value) {
                    _.changeThemeData();
                  },
                );
              },
            ),
            GetBuilder<HomeController>(
              id: UpdateHomePage.switchButtonLanguage,
              builder: (_) {
                return CupertinoSwitch(
                  value: _.isVietNamese,
                  onChanged: (value) {
                    _.changeLanguageApp();
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
