import 'package:genius_ai/constants/api_constant.dart';
import 'package:genius_ai/model/recipe.dart';
import 'package:genius_ai/model/recipe_request.dart';
import 'package:genius_ai/services/custom_http.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/state_manager.dart';

class RecipeController extends GetxController {
  RxBool isLoading = false.obs;
  RxString searchQuery = "".obs;
  final RxList<RecipeRequest> myRequests = <RecipeRequest>[].obs;
  final Rx<Summary?> requestSummary = Rx<Summary?>(null);

  var recipeList = <Recipe>[].obs;

  @override
  void onInit() {
    super.onInit();
    getRecipe();
    debounce(
      searchQuery,
      (_) => getRecipe(),
      time: const Duration(milliseconds: 500),
    );
  }

  // Get recipe
  Future<void> getRecipe() async {
    isLoading(true);
    final String url =
        "${ApiConstant.recipes}?search_term=${searchQuery.value}";
    final response = await CustomHttp.get(endpoint: url, need_auth: true);

    if (response.ok) {
      final data = response.data["data"];
      if (data != null) {
        recipeList.assignAll(
          (data as List).map((e) => Recipe.fromJson(e)).toList(),
        );
      } else {
        recipeList.clear();
      }
    } else {
      final message = response.error ?? 'Something went wrong.';
      AppSnackbar.show(message: message, type: SnackType.error);
    }

    isLoading(false);
  }

  // Add recipe
  Future<bool> postRecipe({
    required String name,
    required String avgTime,
    required String instruction,
    required String sellingCost,
    required List<Map<String, dynamic>> ingredients,
  }) async {
    isLoading(true);

    final Map<String, dynamic> body = {
      "name": name,
      "avg_time": int.tryParse(avgTime.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
      "instruction": instruction,
      "selling_cost": sellingCost.replaceAll('\$', '').trim(),
      "ingredients": ingredients,
    };

    final response = await CustomHttp.post(
      endpoint: ApiConstant.recipes,
      body: body,
      need_auth: true,
    );

    isLoading(false);

    if (response.ok) {
      AppSnackbar.show(
        message: "Recipe added successfully!",
        type: SnackType.success,
      );
      getRecipe();
      return true;
    } else {
      AppSnackbar.show(
        message: response.error ?? "Failed to add recipe",
        type: SnackType.error,
      );
      return false;
    }
  }

  // Update recipe
  Future<bool> updateRecipe({
    required int id,
    required String name,
    required String avgTime,
    required String instruction,
    required String sellingCost,
    required List<Map<String, dynamic>> ingredients,
  }) async {
    isLoading(true);

    final Map<String, dynamic> body = {
      "name": name,
      "avg_time": int.tryParse(avgTime.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
      "instruction": instruction,
      "selling_cost": sellingCost.replaceAll('\$', '').trim(),
      "ingredients": ingredients,
    };

    final String url = "${ApiConstant.recipes}/$id";
    final response = await CustomHttp.patch(
      endpoint: url,
      body: body,
      need_auth: true,
    );

    isLoading(false);

    if (response.ok) {
      AppSnackbar.show(
        message: "Recipe updated successfully!",
        type: SnackType.success,
      );
      getRecipe();
      return true;
    } else {
      AppSnackbar.show(
        message: response.error ?? "Update failed",
        type: SnackType.error,
      );
      return false;
    }
  }

  Future<void> fetchMyRecipeRequests({String status = ""}) async {
    isLoading(true);

    String url = "${ApiConstant.recipes}/my-requests";
    if (status.isNotEmpty) {
      url += "?approval_status=$status";
    }

    final response = await CustomHttp.get(endpoint: url, need_auth: true);

    if (response.ok) {
      final recipeResponse = RecipeRequestResponse.fromJson(response.data);
      myRequests.assignAll(recipeResponse.data ?? []);
      requestSummary.value = recipeResponse.summary;
    } else {
      AppSnackbar.show(
        message: response.error ?? 'Error',
        type: SnackType.error,
      );
    }
    isLoading(false);
  }
}
