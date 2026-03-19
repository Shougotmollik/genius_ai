import 'package:genius_ai/constants/api_constant.dart';
import 'package:genius_ai/model/notification_model.dart';
import 'package:genius_ai/services/custom_http.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  RxBool isLoading = false.obs;
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  // get all notification
  Future<void> getNotifications() async {
    isLoading(true);
    final String url = ApiConstant.notification;
    final response = await CustomHttp.get(endpoint: url, need_auth: true);
    isLoading(false);
    if (response.ok) {
      final data = response.data;
      notifications.assignAll(
        (data as List).map((e) => NotificationModel.fromJson(e)).toList(),
      );
    } else {
      final message = response.error ?? 'Something went wrong.';
      AppSnackbar.show(message: message, type: SnackType.error);
    }
  }
}
