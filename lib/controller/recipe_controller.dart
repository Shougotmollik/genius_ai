import 'package:genius_ai/constants/api_constant.dart';
import 'package:genius_ai/model/recipe.dart';
import 'package:genius_ai/model/recipe_request.dart';
import 'package:genius_ai/services/custom_http.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/get.dart' hide SnackPosition;
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
  Future<bool> postRecipe({required List<Map<String, dynamic>> recipes}) async {
    isLoading(true);

    final response = await CustomHttp.post(
      endpoint: ApiConstant.recipes,
      body: recipes,
      need_auth: true,
    );

    isLoading(false);

    if (response.ok) {
      AppSnackbar.show(
        message: "Recipes added successfully!",
        type: SnackType.success,
      );
      getRecipe();
      return true;
    } else {
      AppSnackbar.show(
        message: response.error ?? "Failed to add recipes",
        type: SnackType.error,
        position: SnackPosition.top,
      );
      return false;
    }
  }

  // Update recipe
  Future<bool> updateRecipe({
    required List<Map<String, dynamic>> recipes,
  }) async {
    isLoading(true);

    final String url = ApiConstant.recipes;
    final response = await CustomHttp.patch(
      endpoint: url,
      body: recipes,
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

  // Delete recipe
  Future<bool> deleteRecipe({required String id}) async {
    isLoading(true);

    final String url = "${ApiConstant.recipes}/$id";
    final response = await CustomHttp.delete(endpoint: url, need_auth: true);
    isLoading(false);

    if (response.ok) {
      AppSnackbar.show(
        message: "Recipe deleted successfully!",
        type: SnackType.success,
      );
      getRecipe();
      return true;
    } else {
      AppSnackbar.show(
        message: response.error ?? "Delete failed",
        type: SnackType.error,
      );
      return false;
    }
  }

  // Fetch my recipe requests
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
