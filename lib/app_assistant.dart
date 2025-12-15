import 'package:get/get.dart';

class AppAssistant extends GetxController {
  static AppAssistant get access =>
      GetInstance().putOrFind(() => AppAssistant());

  RxString notificationCount = ''.obs;
}
