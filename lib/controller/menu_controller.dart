import 'package:genius_ai/constants/api_constant.dart';
import 'package:genius_ai/model/dish.dart';
import 'package:genius_ai/model/menu.dart';
import 'package:genius_ai/model/menu_request.dart';
import 'package:genius_ai/services/custom_http.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/get.dart';

class BarMenuController extends GetxController {
  RxBool isLoading = false.obs;
  RxString searchQuery = "".obs;
  final RxList<Menu> menuList = <Menu>[].obs;
  final RxList<Dish> dishList = <Dish>[].obs;

  final RxList<Menu> requestList = <Menu>[].obs;
  final Rx<Summary?> menuRequest = Rx<Summary?>(null);

  @override
  void onInit() {
    super.onInit();
    getMenu();
    debounce(
      searchQuery,
      (_) => getMenu(),
      time: const Duration(milliseconds: 500),
    );
    getDishes();
    fetchRequests(status: "");
  }

  // Get menu
  Future<void> getMenu() async {
    isLoading(true);
    final String url = "${ApiConstant.menu}?search_term=${searchQuery.value}";
    final response = await CustomHttp.get(endpoint: url, need_auth: true);

    if (response.ok) {
      final data = response.data["data"];
      if (data != null) {
        menuList.assignAll(
          (data as List).map((e) => Menu.fromJson(e)).toList(),
        );
      } else {
        menuList.clear();
      }
    } else {
      final message = response.error ?? 'Something went wrong.';
      AppSnackbar.show(message: message, type: SnackType.error);
    }
    isLoading(false);
  }

  // Get available dishes
  Future<void> getDishes() async {
    isLoading(true);

    final response = await CustomHttp.get(
      endpoint: ApiConstant.dishes,
      need_auth: true,
    );
    isLoading(false);
    if (response.ok) {
      final data = response.data["data"];
      if (data != null) {
        dishList.assignAll(
          (data as List).map((e) => Dish.fromJson(e)).toList(),
        );
      } else {
        dishList.clear();
      }
    } else {
      final message = response.error ?? 'Something went wrong.';
      AppSnackbar.show(message: message, type: SnackType.error);
    }
  }

  // Add menu
  Future<bool> addMenu({required List<Map<String, dynamic>> menu}) async {
    isLoading(true);

    final response = await CustomHttp.post(
      endpoint: ApiConstant.menu,
      body: menu,
      need_auth: true,
    );

    isLoading(false);

    if (response.ok) {
      if (menu.length > 1) {
        AppSnackbar.show(
          message: "Menus added successfully!",
          type: SnackType.success,
        );
      }
      getMenu();
      return true;
    } else {
      AppSnackbar.show(
        message: response.error ?? "Error",
        type: SnackType.error,
      );
      return false;
    }
  }

  Future<void> fetchRequests({String status = ""}) async {
    isLoading(true);

    String url = "${ApiConstant.menu}/my-requests";
    if (status.isNotEmpty) {
      url += "?approval_status=$status";
    }
    final response = await CustomHttp.get(endpoint: url, need_auth: true);

    if (response.ok) {
      final menuResponse = MenuRequest.fromJson(response.data);
      requestList.assignAll(menuResponse.data ?? []);
      menuRequest.value = menuResponse.summary;
    } else {
      AppSnackbar.show(
        message: response.error ?? 'Error',
        type: SnackType.error,
      );
    }
    isLoading(false);
  }

  Future<bool> updateMenu({required List<Map<String, dynamic>> menu}) async {
    isLoading(true);
    final response = await CustomHttp.patch(
      endpoint: ApiConstant.menu,
      body: menu,
      need_auth: true,
    );
    isLoading(false);
    if (response.ok) {
      AppSnackbar.show(
        message: "Menu updated successfully!",
        type: SnackType.success,
      );
      getMenu();
      return true;
    } else {
      AppSnackbar.show(
        message: response.error ?? "Update failed",
        type: SnackType.error,
      );
      return false;
    }
  }

  Future<bool> deleteMenu({required String id}) async {
    isLoading(true);
    final String url = "${ApiConstant.menu}/$id";
    final response = await CustomHttp.delete(endpoint: url, need_auth: true);
    isLoading(false);
    if (response.ok) {
      AppSnackbar.show(
        message: "Menu deleted successfully!",
        type: SnackType.success,
      );
      getMenu();
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
