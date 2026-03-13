import 'package:genius_ai/controller/home_controller.dart';
import 'package:genius_ai/controller/ingredient_controller.dart';
import 'package:genius_ai/controller/menu_controller.dart';
import 'package:genius_ai/controller/recipe_controller.dart';
import 'package:genius_ai/controller/auth_controller.dart';
import 'package:genius_ai/controller/user_controller.dart';
import 'package:get/get.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<IngredientController>(() => IngredientController());
    Get.lazyPut<RecipeController>(() => RecipeController());
    Get.lazyPut<BarMenuController>(() => BarMenuController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
