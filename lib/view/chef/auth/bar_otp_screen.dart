import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/view/widgets/primary_button.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class BarOtpVerificationScreen extends StatefulWidget {
  const BarOtpVerificationScreen({super.key});

  @override
  State<BarOtpVerificationScreen> createState() =>
      _BarOtpVerificationScreenState();
}

class _BarOtpVerificationScreenState extends State<BarOtpVerificationScreen> {
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _canResend = false;

  final TextEditingController otpTEController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _canResend = false;
      _secondsRemaining = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onResendPressed() {
    debugPrint("Resend Code clicked");
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 48.h),
              Text(
                'Enter OTP',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),

              SizedBox(height: 36.h),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'A 6 digit verification code has been sent to ',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.text,
                    fontSize: 14.sp,
                  ),
                  children: [
                    TextSpan(
                      text: 'example@gmail.com',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              Pinput(
                controller: otpTEController,
                keyboardType: TextInputType.number,
                length: 6,
                defaultPinTheme: PinTheme(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),

                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.8),
                      width: 2.w,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  width: 44.w,
                  height: 44.h,
                ),
              ),

              SizedBox(height: 24.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn’t get OTP?",
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  _canResend
                      ? GestureDetector(
                          onTap: _onResendPressed,
                          child: Text(
                            'Resent',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Resend Code in ',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 14.sp,
                                  ),
                            ),
                            Text(
                              '$_secondsRemaining s',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ],
              ),

              SizedBox(height: 42.h),

              CustomElevatedButton(
                btnText: 'Verify',
                onTap: () {
                  Get.toNamed(RouteNames.barCreateNewPassword);
                },
              ),

              SizedBox(height: 42.h),
            ],
          ),
        ),
      ),
    );
  }
}
