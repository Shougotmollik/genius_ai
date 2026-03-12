import 'dart:io';

import 'package:genius_ai/constants/api_constant.dart';
import 'package:genius_ai/model/leave_request.dart';
import 'package:genius_ai/model/user.dart';
import 'package:genius_ai/services/custom_http.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  RxBool isLoading = false.obs;

  final RxList<LeaveRequest> leaveList = <LeaveRequest>[].obs;
  var user = UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    getLeaveRequest();
    getUser();
  }

  // Fetch user details
  Future<void> getUser() async {
    isLoading(true);
    final String url = ApiConstant.user;
    final response = await CustomHttp.get(endpoint: url, need_auth: true);
    isLoading(false);
    if (response.ok) {
      final data = response.data["data"];
      user.value = UserModel.fromJson(data);
    } else {
      final message = response.error ?? 'Something went wrong.';
      AppSnackbar.show(message: message, type: SnackType.error);
    }
  }

  // Update user image
  Future<void> updateProfileImage(File image) async {
    try {
      isLoading(true);

      var response = await CustomHttp.multipart(
        endpoint: ApiConstant.user,
        fieldName: 'avatar',
        filePath: image.path,
        method: 'PATCH',
      );

      if (response.ok) {
        AppSnackbar.show(
          message: "Profile image updated",
          type: SnackType.success,
        );

        await getUser();
      } else {
        final message = response.error ?? 'Something went wrong.';
        AppSnackbar.show(message: message, type: SnackType.error);
      }
    } finally {
      isLoading(false);
    }
  }

  // Update user details
  Future<bool> updateUserName({required String name}) async {
    isLoading(true);

    final Map<String, dynamic> body = {"full_name": name};

    final response = await CustomHttp.patch(
      endpoint: ApiConstant.user,
      body: body,
      need_auth: true,
    );

    isLoading(false);

    if (response.ok) {
      final message = response.data['message'] ?? 'User updated';
      AppSnackbar.show(message: message, type: SnackType.success);
      return true;
    } else {
      final message = response.error ?? 'Something went wrong.';
      AppSnackbar.show(message: message, type: SnackType.error);
      return false;
    }
  }

  // update user cv
  Future<void> updateUserCv({required File cv}) async {
    try {
      isLoading(true);

      var response = await CustomHttp.multipart(
        endpoint: ApiConstant.user,
        fieldName: 'my_cv',
        filePath: cv.path,
        method: 'PATCH',
      );

      if (response.ok) {
        AppSnackbar.show(message: "CV updated", type: SnackType.success);

        await getUser();
      } else {
        final message = response.error ?? 'Something went wrong.';
        AppSnackbar.show(message: message, type: SnackType.error);
      }
    } finally {
      isLoading(false);
    }
  }

  // update user password
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final Map<String, dynamic> body = {
      "current_password": currentPassword,
      "new_password": newPassword,
      "confirm_password": confirmPassword,
    };

    final response = await CustomHttp.patch(
      endpoint: ApiConstant.user,
      body: body,
      need_auth: true,
    );

    if (response.ok) {
      final message = response.data['message'] ?? 'Password updated';
      AppSnackbar.show(message: message, type: SnackType.success);
      return true;
    } else {
      final message = response.error ?? 'Something went wrong.';
      AppSnackbar.show(message: message, type: SnackType.error);
      return false;
    }
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

  // edit Request send
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
