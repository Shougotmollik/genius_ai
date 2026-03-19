import 'package:genius_ai/constants/api_constant.dart';
import 'package:genius_ai/model/purchase.dart';
import 'package:genius_ai/services/custom_http.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/get.dart';

class PurchaseController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Purchase> purchases = <Purchase>[].obs;
  RxString searchQuery = "".obs;
  RxBool isSpecialTab = false.obs;

  @override
  void onInit() {
    super.onInit();
    getPurchases();
    debounce(
      searchQuery,
      (_) => getPurchases(),
      time: const Duration(milliseconds: 500),
    );
    ever(isSpecialTab, (_) => getPurchases());
  }

  Future<void> getPurchases() async {
    isLoading(true);
    try {
      final String url =
          "${ApiConstant.purchases}?"
          "search_term=${searchQuery.value}&"
          "is_special=${isSpecialTab.value}";

      final response = await CustomHttp.get(endpoint: url, need_auth: true);

      if (response.ok) {
        final data = response.data["data"];
        if (data != null) {
          purchases.assignAll(
            (data as List).map((json) => Purchase.fromJson(json)),
          );
        } else {
          purchases.clear();
        }
      } else {
        purchases.clear();
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> addPurchase({
    required List<Map<String, dynamic>> purchases,
  }) async {
    isLoading(true);
    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstant.purchases,
        body: purchases,
        need_auth: true,
      );

      if (response.ok) {
        AppSnackbar.show(
          message: "Purchase added successfully",
          type: SnackType.success,
        );
        getPurchases();
      } else {
        AppSnackbar.show(
          message: response.error ?? "Failed to add purchase",
          type: SnackType.error,
        );
      }
    } finally {
      isLoading(false);
    }
  }
}
