import 'package:get/route_manager.dart';

import 'en.dart';
import 'vi.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'vi': vi,
      };
}
