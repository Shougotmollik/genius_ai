import 'package:genius_ai/constants/api_constant.dart';
import 'package:genius_ai/model/ingredient.dart';
import 'package:genius_ai/model/ingredient_catergory.dart';
import 'package:genius_ai/model/request_ingredient.dart';
import 'package:genius_ai/services/custom_http.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/get.dart';

class IngredientController extends GetxController {
  RxBool isLoading = false.obs;
  final RxList<Ingredient> ingredientList = <Ingredient>[].obs;
  RxString searchQuery = "".obs;
  RxBool isSpecialTab = false.obs;
  RxBool isSpecial = false.obs;

  final RxList<Ingredient> requestList = <Ingredient>[].obs;
  final Rx<Summary?> summary = Rx<Summary?>(null);

  final RxList<IngredientCategory> categoryList = <IngredientCategory>[].obs;

  @override
  void onInit() {
    super.onInit();
    getIngredient();
    debounce(
      searchQuery,
      (_) => getIngredient(),
      time: const Duration(milliseconds: 500),
    );
    ever(isSpecialTab, (_) => getIngredient());
    fetchRequests(status: "");
    getCategories();
  }

  Future<void> getIngredient() async {
    isLoading(true);
    final String url =
        "${ApiConstant.ingredients}?"
        "search_term=${searchQuery.value}&"
        "is_special=${isSpecialTab.value}&"
        "approval_status=approved";

    final response = await CustomHttp.get(endpoint: url, need_auth: true);

    if (response.ok) {
      final data = response.data["data"];
      if (data != null) {
        ingredientList.assignAll(
          (data as List).map((e) => Ingredient.fromJson(e)).toList(),
        );
      } else {
        ingredientList.clear();
      }
    } else {
      final message = response.error ?? 'Something went wrong.';
      AppSnackbar.show(message: message, type: SnackType.error);
    }

    isLoading(false);
  }

  Future<void> fetchRequests({String status = ""}) async {
    isLoading(true);

    String url = "${ApiConstant.ingredients}/my-requests";
    if (status.isNotEmpty) {
      url += "?approval_status=$status";
    }

    final response = await CustomHttp.get(endpoint: url, need_auth: true);

    if (response.ok) {
      final ingredientResponse = IngredientResponse.fromJson(response.data);

      requestList.assignAll(ingredientResponse.data ?? []);
      summary.value = ingredientResponse.summary;
    } else {
      AppSnackbar.show(
        message: response.error ?? 'Error',
        type: SnackType.error,
      );
    }

    isLoading(false);
  }

  Future<void> getCategories() async {
    final response = await CustomHttp.get(
      endpoint: ApiConstant.ingredientCategories,
      need_auth: true,
    );
    if (response.ok) {
      final data = response.data["data"] as List;
      categoryList.assignAll(
        data.map((e) => IngredientCategory.fromJson(e)).toList(),
      );
    }
  }

  Future<bool> postIngredient({
    required List<Map<String, dynamic>> ingredients,
  }) async {
    isLoading(true);

    final response = await CustomHttp.post(
      endpoint: ApiConstant.ingredients,
      body: ingredients,
      need_auth: true,
    );

    isLoading(false);

    if (response.ok) {
      AppSnackbar.show(
        message: ingredients.length > 1
            ? "Batch ingredients added successfully!"
            : "Ingredient added successfully!",
        type: SnackType.success,
      );
      getIngredient();
      return true;
    } else {
      AppSnackbar.show(
        message: response.error ?? "Error",
        type: SnackType.error,
      );
      return false;
    }
  }

  Future<bool> updateIngredient({
    required List<Map<String, dynamic>> ingredients,
  }) async {
    isLoading(true);
    final response = await CustomHttp.patch(
      endpoint: ApiConstant.updateIngredient,
      body: ingredients,
      need_auth: true,
    );
    isLoading(false);
    if (response.ok) {
      AppSnackbar.show(
        message: "Ingredient updated successfully!",
        type: SnackType.success,
      );
      getIngredient();
      return true;
    } else {
      AppSnackbar.show(
        message: response.error ?? "Update failed",
        type: SnackType.error,
      );
      return false;
    }
  }

  Future<bool> deleteIngredient({required String id}) async {
    isLoading(true);
    final String url = "${ApiConstant.ingredients}/$id";
    final response = await CustomHttp.delete(endpoint: url, need_auth: true);
    isLoading(false);
    if (response.ok) {
      AppSnackbar.show(
        message: "Ingredient deleted successfully!",
        type: SnackType.success,
      );
      getIngredient();
      return true;
    } else {
      AppSnackbar.show(
        message: response.error ?? "Delete failed",
        type: SnackType.error,
      );
      return false;
    }
  }
}
