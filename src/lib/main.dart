import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:src/routes/routes.dart';

import 'core/themes/theme.dart';
import 'core/translations/app_translations.dart';
import 'core/utils/dependency.dart';
import 'routes/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
  await Dependency.init();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      defaultTransition: Transition.cupertino,
      getPages: AppPages.pages,
      initialRoute: AppRoutes.home,
      theme: AppTheme.dark,
    ),
  );
}
