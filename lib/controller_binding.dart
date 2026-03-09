import 'package:genius_ai/controller/bar/ingredient_controller.dart';
import 'package:genius_ai/controller/bar/recipe_controller.dart';
import 'package:genius_ai/controller/common/auth_controller.dart';
import 'package:get/get.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.lazyPut<IngredientController>(() => IngredientController());
    Get.lazyPut<RecipeController>(() => RecipeController());
  }
}
