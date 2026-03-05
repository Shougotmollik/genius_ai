import 'package:genius_ai/controller/common/auth_controller.dart';
import 'package:get/get.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}
