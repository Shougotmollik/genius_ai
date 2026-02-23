import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';

class AuthTextFormField extends StatefulWidget {
  const AuthTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.isPassword = false,
    this.prefixIconPath,
  });

  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final String? prefixIconPath;

  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.lightText, width: 1.w),
      ),
      child: Row(
        children: [
          if (widget.prefixIconPath != null)
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: SvgPicture.asset(
                widget.prefixIconPath!,
                height: 20.h,
                width: 20.w,
                colorFilter: ColorFilter.mode(
                  AppColors.lightText,
                  BlendMode.srcIn,
                ),
              ),
            ),

          Expanded(
            child: TextFormField(
              controller: widget.controller,
              validator: widget.validator,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              obscureText: _obscureText,
              autocorrect: !widget.isPassword,
              enableSuggestions: !widget.isPassword,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: AppColors.text,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.lightText,
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 14.h,
                  horizontal: 12.w,
                ),
                border: InputBorder.none,
                suffixIcon: widget.isPassword
                    ? IconButton(
                        splashRadius: 20,
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.text,
                        ),
                        onPressed: () {
                          setState(() => _obscureText = !_obscureText);
                        },
                      )
                    : null,
                errorStyle: TextStyle(fontSize: 11.sp, color: AppColors.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
