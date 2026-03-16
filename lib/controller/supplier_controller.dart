import 'package:genius_ai/constants/api_constant.dart';
import 'package:genius_ai/model/supplier.dart';
import 'package:genius_ai/model/supplier_request.dart';
import 'package:genius_ai/services/custom_http.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/get.dart';

class SupplierController extends GetxController {
  RxBool isLoading = false.obs;
  RxString searchQuery = "".obs;
  final RxList<Supplier> supplierList = <Supplier>[].obs;
  final Rx<Supplier?> supplierDetails = Rx<Supplier?>(null);

  final RxList<Supplier> supplierRequestList = <Supplier>[].obs;
  final Rx<SupplierRequestSummary?> supplierRequestSummary =
      Rx<SupplierRequestSummary?>(null);
  @override
  void onInit() {
    super.onInit();
    getSupplier();
    debounce(
      searchQuery,
      (_) => getSupplier(),
      time: const Duration(milliseconds: 500),
    );
    fetchSupplierRequests(status: "");
  }

  // get supplier
  Future<void> getSupplier() async {
    isLoading(true);
    final String url =
        "${ApiConstant.supplier}?search_term=${searchQuery.value}";
    final response = await CustomHttp.get(endpoint: url, need_auth: true);
    isLoading(false);
    if (response.ok) {
      final data = response.data["data"];
      supplierList.assignAll(
        (data as List).map((e) => Supplier.fromJson(e)).toList(),
      );
    } else {
      final message = response.error ?? 'Something went wrong.';
      AppSnackbar.show(message: message, type: SnackType.error);
    }
  }

  // get supplier details
  Future<void> getSupplierDetails({required String id}) async {
    isLoading(true);
    final String url = "${ApiConstant.supplier}/$id";
    final response = await CustomHttp.get(endpoint: url, need_auth: true);
    isLoading(false);
    if (response.ok) {
      final data = response.data["data"];
      supplierDetails.value = Supplier.fromJson(data);
    } else {
      final message = response.error ?? 'Something went wrong.';
      AppSnackbar.show(message: message, type: SnackType.error);
    }
  }

  // add supplier
  Future<bool> addSupplier({required Map<String, dynamic> body}) async {
    isLoading(true);
    final response = await CustomHttp.post(
      endpoint: ApiConstant.supplier,
      body: body,
      need_auth: true,
    );
    isLoading(false);
    if (response.ok) {
      final message = response.data['message'] ?? 'Supplier added';
      AppSnackbar.show(message: message, type: SnackType.success);
      return true;
    } else {
      final message = response.error ?? 'Something went wrong.';
      AppSnackbar.show(message: message, type: SnackType.error);
      return false;
    }
  }

  // fetch supplier request
  Future<void> fetchSupplierRequests({String status = ""}) async {
    isLoading(true);
    String url = "${ApiConstant.supplier}/my-requests";
    if (status.isNotEmpty) {
      url += "?approval_status=$status";
    }
    final response = await CustomHttp.get(endpoint: url, need_auth: true);
    isLoading(false);
    if (response.ok) {
      final supplierResponse = SupplierRequest.fromJson(response.data);
      supplierRequestList.assignAll(supplierResponse.data ?? []);
      supplierRequestSummary.value = supplierResponse.summary;
    } else {
      AppSnackbar.show(
        message: response.error ?? 'Error',
        type: SnackType.error,
      );
    }
  }

  // edit supplier
  Future<bool> editSupplier({
    required Map<String, dynamic> body,
    required String id,
  }) async {
    isLoading(true);
    final response = await CustomHttp.patch(
      endpoint: "${ApiConstant.supplier}/$id",
      body: body,
      need_auth: true,
    );
    isLoading(false);
    if (response.ok) {
      final message = response.data['message'] ?? 'Supplier updated';
      AppSnackbar.show(message: message, type: SnackType.success);
      getSupplier();
      return true;
    } else {
      final message = response.error ?? 'Something went wrong.';
      AppSnackbar.show(message: message, type: SnackType.error);
      return false;
    }
  }

  // delete supplier
  Future<bool> deleteSupplier({required String id}) async {
    isLoading(true);
    final response = await CustomHttp.delete(
      endpoint: "${ApiConstant.supplier}/$id",
      need_auth: true,
    );
    isLoading(false);
    if (response.ok) {
      final message = response.data['message'] ?? 'Supplier deleted';
      AppSnackbar.show(message: message, type: SnackType.success);
      getSupplier();
      return true;
    } else {
      final message = response.error ?? 'Something went wrong.';
      AppSnackbar.show(message: message, type: SnackType.error);
      return false;
    }
  }
}
