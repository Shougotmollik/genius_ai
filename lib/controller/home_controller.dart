import 'package:genius_ai/constants/api_constant.dart';
import 'package:genius_ai/model/home.dart';
import 'package:genius_ai/services/custom_http.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;

  final Rxn<HomeData> homeData = Rxn<HomeData>();

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    isLoading(true);
    final response = await CustomHttp.get(
      endpoint: ApiConstant.home,
      need_auth: true,
    );
    isLoading(false);
    if (response.ok) {
      final data = response.data["data"];
      if (data != null) {
        homeData.value = HomeData.fromJson(data);
      }
    } else {
      final message = response.error ?? 'Something went wrong.';
      AppSnackbar.show(message: message, type: SnackType.error);
    }
  }
}
