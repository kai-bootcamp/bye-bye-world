import 'package:get/route_manager.dart';
import 'package:src/app/views/home/home_binding.dart';
import 'package:src/app/views/home/home_page.dart';
import 'package:src/routes/routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
  ];
}
