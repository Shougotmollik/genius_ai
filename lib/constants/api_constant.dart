class ApiConstant {
  // Auth
  static const String signup = "/auth/sign-up";
  static const String signupOtpVerification = "/auth/verify-email";
  static const String resendOtp = "/auth/resend-verification-code";
  static const String signin = "/auth/sign-in";
  static const String forgetPassword = "/auth/forgot-password";
  static const String forgetOtpVerification = "/auth/verify-reset-code";
  static const String resetPassword = "/auth/reset-password";
  static const String user = "/settings/personal-info/me";

  // bar
  static const String ingredients = "/ingredients";
  static const String updateIngredient = "/ingredients/bulk-update";
  static const String ingredientCategories = "/ingredients/categories";
  static const String recipes = "/recipes";
  static const String leaveRequest = "/staff/leave-requests";
}
