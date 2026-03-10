import 'package:genius_ai/constants/api_constant.dart';
import 'package:genius_ai/services/custom_http.dart';
import 'package:genius_ai/services/local_storage.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  // user signup
  Future<Map<String, String>?> signup({
    required String name,
    required String emailAddress,
    required String password,
    required String confirmPassword,
    required String mode,
  }) async {
    try {
      isLoading.value = true;
      final response = await CustomHttp.post(
        show_floating_error: false,
        endpoint: ApiConstant.signup,
        body: {
          "mode": mode.trim(),
          "full_name": name,
          "email_address": emailAddress.trim(),
          "password": password,
          "confirm_password": confirmPassword,
        },
        need_auth: false,
      );

      final data = response.data ?? {};

      if (response.ok) {
        final userId = data['user_id'] ?? '';
        final message = data['message'] ?? 'Account created successfully';
        AppSnackbar.show(message: message, type: SnackType.success);

        return {'user_id': userId, 'email_address': emailAddress};
      } else {
        final message = response.error ?? 'Something went wrong.';
        AppSnackbar.show(message: message, type: SnackType.error);
        return null;
      }
    } catch (e) {
      AppSnackbar.show(
        message: 'Network error. Try again.',
        type: SnackType.error,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // user sign up otp verification
  Future<bool> signupOtpVerification({
    required String userId,
    required String otp,
  }) async {
    try {
      isLoading.value = true;

      final response = await CustomHttp.post(
        endpoint: ApiConstant.signupOtpVerification,
        body: {"user_id": userId, "verification_code": otp.trim()},
        need_auth: false,
      );

      final data = response.data ?? {};

      if (response.ok) {
        final message =
            data['message'] ??
            'OTP verified successfully. Wait for admin approval';
        AppSnackbar.show(message: message, type: SnackType.success);

        return true;
      } else {
        final message = response.error ?? 'Something went wrong.';
        AppSnackbar.show(message: message, type: SnackType.error);
        return false;
      }
    } catch (e) {
      AppSnackbar.show(
        message: 'Network error. Try again.',
        type: SnackType.error,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Otp Resent
  Future<bool> otpResent({required String userId}) async {
    try {
      isLoading.value = true;

      final response = await CustomHttp.post(
        endpoint: ApiConstant.resendOtp,
        body: {"user_id": userId},
        need_auth: false,
      );

      final data = response.data ?? {};

      if (response.ok) {
        final message = data['message'] ?? 'OTP resent successfully';
        AppSnackbar.show(message: message, type: SnackType.success);

        return true;
      } else {
        final message = response.error ?? 'Something went wrong.';
        AppSnackbar.show(message: message, type: SnackType.error);
        return false;
      }
    } catch (e) {
      AppSnackbar.show(
        message: 'Network error. Try again.',
        type: SnackType.error,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // user login
  Future<bool> login({
    required String emailAddress,
    required String password,
    required String mode,
  }) async {
    try {
      isLoading.value = true;

      final response = await CustomHttp.post(
        show_floating_error: false,
        endpoint: ApiConstant.signin,
        body: {
          "mode": mode.trim(),
          "email_address": emailAddress.trim(),
          "password": password,
        },
        need_auth: false,
      );

      final data = response.data ?? {};

      if (response.ok) {
        final message = data['message'] ?? 'Login successful';
        AppSnackbar.show(message: message, type: SnackType.success);

        final user = data['user'] ?? {};
        await LocalStorage.access_token.set(data['access_token'] ?? '');
        await LocalStorage.refresh_token.set(data['refresh_token'] ?? '');
        await LocalStorage.user_id.set(user['id'] ?? '');
        await LocalStorage.role.set(user['role'] ?? '');

        return true;
      } else {
        final message = response.error ?? 'Something went wrong.';
        AppSnackbar.show(message: message, type: SnackType.error);
        return false;
      }
    } catch (e) {
      AppSnackbar.show(
        message: 'Network error. Try again.',
        type: SnackType.error,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // user forget password
  Future<Map<String, String>?> forgetPassword({
    required String emailAddress,
  }) async {
    try {
      isLoading.value = true;

      final response = await CustomHttp.post(
        show_floating_error: false,
        endpoint: ApiConstant.forgetPassword,
        body: {"email_address": emailAddress.trim()},
        need_auth: false,
      );

      final data = response.data ?? {};

      if (response.ok) {
        final userId = data['user_id'] ?? '';
        final message = data['message'] ?? 'Account created successfully';
        AppSnackbar.show(message: message, type: SnackType.success);

        return {'user_id': userId, 'email_address': emailAddress};
      } else {
        final message = response.error ?? 'Something went wrong.';
        AppSnackbar.show(message: message, type: SnackType.error);
        return null;
      }
    } catch (e) {
      AppSnackbar.show(
        message: 'Network error. Try again.',
        type: SnackType.error,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // user forgot otp verification
  Future<String?> otpVerification({
    required String userId,
    required String otp,
  }) async {
    try {
      isLoading.value = true;

      final response = await CustomHttp.post(
        endpoint: ApiConstant.forgetOtpVerification,
        body: {"user_id": userId, "verification_code": otp.trim()},
        need_auth: false,
      );

      final data = response.data ?? {};

      if (response.ok) {
        final message =
            data['message'] ??
            'OTP verified successfully. Wait for admin approval';
        AppSnackbar.show(message: message, type: SnackType.success);

        return data["secret_key"];
      } else {
        final message = response.error ?? 'Something went wrong.';
        AppSnackbar.show(message: message, type: SnackType.error);
        return null;
      }
    } catch (e) {
      AppSnackbar.show(
        message: 'Network error. Try again.',
        type: SnackType.error,
      );
      print(e);

      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // User Change Password
  Future<bool> changePassword({
    required String userId,
    required String secretKey,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;

      final response = await CustomHttp.post(
        endpoint: ApiConstant.resetPassword,
        body: {
          "user_id": userId,
          "secret_key": secretKey,
          "new_password": newPassword,
          "confirm_password": confirmPassword,
        },
        need_auth: false,
      );

      final data = response.data ?? {};

      if (response.ok) {
        final message = data['message'] ?? 'Password changed successfully';
        AppSnackbar.show(message: message, type: SnackType.success);

        return true;
      } else {
        final message = response.error ?? 'Something went wrong.';
        AppSnackbar.show(message: message, type: SnackType.error);
        return false;
      }
    } catch (e) {
      AppSnackbar.show(
        message: 'Network error. Try again.',
        type: SnackType.error,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> logout() async {
    await LocalStorage.clear();
    return true;
  }
}
