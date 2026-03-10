import 'package:genius_ai/constants/api_constant.dart';
import 'package:genius_ai/model/leave_request.dart';
import 'package:genius_ai/services/custom_http.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  RxBool isLoading = false.obs;

  final RxList<LeaveRequest> leaveList = <LeaveRequest>[].obs;

  @override
  void onInit() {
    super.onInit();
    getLeaveRequest();
  }

  // Leave Request send
  Future<bool> sendLeaveRequest({
    required String leaveType,
    required String startDate,
    required String endDate,
    required String reason,
  }) async {
    isLoading(true);

    final Map<String, dynamic> body = {
      "leave_type": leaveType,
      "start_date": startDate,
      "end_date": endDate,
      "reason": reason,
    };

    final response = await CustomHttp.post(
      endpoint: ApiConstant.leaveRequest,
      body: body,
      need_auth: true,
    );

    isLoading(false);

    if (response.ok) {
      final message = response.data['message'] ?? 'Leave request sent';
      AppSnackbar.show(message: message, type: SnackType.success);
      return true;
    } else {
      final message = response.error ?? 'Something went wrong.';
      AppSnackbar.show(message: message, type: SnackType.error);
      return false;
    }
  }

  // Leave Request history
  Future<void> getLeaveRequest() async {
    isLoading(true);
    final String url = ApiConstant.leaveRequest;
    final response = await CustomHttp.get(endpoint: url, need_auth: true);
    isLoading(false);
    if (response.ok) {
      final data = response.data["data"];
      leaveList.assignAll(
        (data as List).map((e) => LeaveRequest.fromJson(e)).toList(),
      );
    } else {
      final message = response.error ?? 'Something went wrong.';
      AppSnackbar.show(message: message, type: SnackType.error);
    }
  }

  // Leave Request send
  Future<bool> editLeaveRequest({
    required String leaveId,
    required String leaveType,
    required String startDate,
    required String endDate,
    required String reason,
  }) async {
    isLoading(true);

    final Map<String, dynamic> body = {
      "leave_type": leaveType,
      "start_date": startDate,
      "end_date": endDate,
      "reason": reason,
    };

    final response = await CustomHttp.patch(
      endpoint: "${ApiConstant.leaveRequest}/$leaveId",
      body: body,
      need_auth: true,
    );

    isLoading(false);

    if (response.ok) {
      final message = response.data['message'] ?? 'Leave request sent';
      AppSnackbar.show(message: message, type: SnackType.success);
      return true;
    } else {
      final message = response.error ?? 'Something went wrong.';
      AppSnackbar.show(message: message, type: SnackType.error);
      return false;
    }
  }
}
