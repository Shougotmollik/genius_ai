import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/user_controller.dart';
import 'package:genius_ai/model/user.dart';
import 'package:genius_ai/utils/image_picker.dart';
import 'package:get/get.dart';

enum AccountSettingState { view, editName, editPassword, editCV }

class BarAccountSettingScreen extends StatefulWidget {
  const BarAccountSettingScreen({super.key});

  @override
  State<BarAccountSettingScreen> createState() =>
      _BarAccountSettingScreenState();
}

class _BarAccountSettingScreenState extends State<BarAccountSettingScreen>
    with TickerProviderStateMixin {
  // ---- State ----
  AccountSettingState _currentState = AccountSettingState.view;
  late UserModel user;

  // ---- Controllers ----
  late TextEditingController _nameController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  // ---- Visibility ----
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  // ---- Data ----
  String _displayName = '';
  String _email = '';
  String _cvFileName = '';
  bool _hasCv = true;

  // ---- Animation ----
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final UserController _userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    user = Get.arguments as UserModel;
    _displayName = user.fullName ?? 'Guest User';
    _email = user.emailAddress ?? 'Email Not Found';
    if (user.myCv != null && user.myCv!.isNotEmpty) {
      _cvFileName = user.myCv!.split('/').last;
      _hasCv = true;
    } else {
      _cvFileName = 'No CV uploaded';
      _hasCv = false;
    }

    _nameController = TextEditingController(text: _displayName);
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _switchState(AccountSettingState newState) {
    _animController.reverse().then((_) {
      setState(() => _currentState = newState);
      _animController.forward();
    });
  }

  // ---- Actions ----
  void _saveName() {
    setState(() => _displayName = _nameController.text);
    _switchState(AccountSettingState.view);
    _userController.updateUserName(name: _nameController.text);
  }

  void _savePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showSnack('Passwords do not match', isError: true);
      return;
    }
    if (_newPasswordController.text.length < 6) {
      _showSnack('Password must be at least 6 characters', isError: true);
      return;
    }
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    final bool update = await _userController.updatePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    if (update) {
      _switchState(AccountSettingState.view);
    }
  }

  void _cancelEdit() {
    _nameController.text = _displayName;
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    _switchState(AccountSettingState.view);
  }

  void _pickCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return;

    final file = result.files.first;

    setState(() {
      _cvFileName = file.name;
      _hasCv = true;
    });

    _switchState(AccountSettingState.view);

    if (file.path != null) {
      _userController.updateUserCv(cv: File(file.path!));
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : const Color(0xFF2196F3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildAppBar(context),
                _buildProfilePhotoCard(),
                const SizedBox(height: 16),
                _buildPersonalInfoCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---- AppBar ----
  Widget _buildAppBar(BuildContext context) {
    return Row(
      spacing: 18.w,
      children: [
        GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 18,
              color: Colors.black87,
            ),
          ),
        ),

        Text(
          "Account Settings",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }

  // ---- Profile Photo Card ----
  Widget _buildProfilePhotoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: _userController.user.value.avatar != null
                    ? Image.network(
                        _userController.user.value.avatar ?? '',
                        fit: BoxFit.cover,
                        height: 60.w,
                        width: 60.h,
                      )
                    : SizedBox(
                        height: 60.w,
                        width: 60.h,
                        child: Icon(Icons.person),
                      ),
              ),
              Positioned(
                bottom: 0.w,
                right: -10.w,
                child: GestureDetector(
                  onTap: () {
                    showImagePickerOptions(context, (imageSource) async {
                      File? pickedImage = await pickSingleImage(
                        context: context,
                        source: imageSource,
                      );

                      if (pickedImage != null) {
                        _userController.updateProfileImage(pickedImage);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/Camera.svg',
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 20.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _displayName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _email,
                style: TextStyle(fontSize: 14.sp, color: AppColors.lightText),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- Personal Info Card ----
  Widget _buildPersonalInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_currentState) {
      case AccountSettingState.view:
        return _buildViewState();
      case AccountSettingState.editName:
        return _buildEditNameState();
      case AccountSettingState.editPassword:
        return _buildEditPasswordState();
      case AccountSettingState.editCV:
        return _buildEditCVState();
    }
  }

  Widget _buildViewState() {
    return Column(
      children: [
        _buildInfoRow(
          label: 'Name',
          value: _displayName,
          onEdit: () => _switchState(AccountSettingState.editName),
        ),
        _buildDivider(),
        _buildInfoRow(
          label: 'Your Password',
          value: '*******',
          onEdit: () => _switchState(AccountSettingState.editPassword),
        ),
        _buildDivider(),
        _buildInfoRow(
          label: 'Your CV',
          value: _hasCv ? _cvFileName : 'No CV uploaded',
          onEdit: () => _switchState(AccountSettingState.editCV),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required VoidCallback onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.text,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.lightText),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: SvgPicture.asset(
              'assets/icons/edit.svg',
              width: 16.w,
              height: 16.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey.withOpacity(0.15), height: 1);
  }

  Widget _buildEditNameState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _nameController,
          hint: 'Enter your name',
          autofocus: true,
        ),
        const SizedBox(height: 20),
        _buildActionButtons(onCancel: _cancelEdit, onSave: _saveName),
        const SizedBox(height: 20),
        _buildDivider(),
        _buildInfoRow(
          label: 'Your Password',
          value: '********',
          onEdit: () => _switchState(AccountSettingState.editPassword),
        ),
        _buildDivider(),
        _buildInfoRow(
          label: 'Your CV',
          value: _hasCv ? _cvFileName : 'No CV uploaded',
          onEdit: () => _switchState(AccountSettingState.editCV),
        ),
      ],
    );
  }

  //  Edit Password
  Widget _buildEditPasswordState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          label: 'Name',
          value: _displayName,
          onEdit: () => _switchState(AccountSettingState.editName),
        ),
        const SizedBox(height: 16),
        const Text(
          'Current Password',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        _buildPasswordField(
          controller: _currentPasswordController,
          hint: 'Enter Current Password',
          visible: _showCurrentPassword,
          onToggle: () =>
              setState(() => _showCurrentPassword = !_showCurrentPassword),
        ),
        const SizedBox(height: 16),
        const Text(
          'New Password',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        _buildPasswordField(
          controller: _newPasswordController,
          hint: 'Enter New Password',
          visible: _showNewPassword,
          onToggle: () => setState(() => _showNewPassword = !_showNewPassword),
        ),
        const SizedBox(height: 16),
        const Text(
          'Confirm Password',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        _buildPasswordField(
          controller: _confirmPasswordController,
          hint: 'Confirm New Password',
          visible: _showConfirmPassword,
          onToggle: () =>
              setState(() => _showConfirmPassword = !_showConfirmPassword),
        ),
        const SizedBox(height: 24),
        _buildActionButtons(onCancel: _cancelEdit, onSave: _savePassword),
      ],
    );
  }

  Widget _buildEditCVState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          label: 'Name',
          value: _displayName,
          onEdit: () => _switchState(AccountSettingState.editName),
        ),
        _buildDivider(),
        _buildInfoRow(
          label: 'Your Password',
          value: '*********',
          onEdit: () => _switchState(AccountSettingState.editPassword),
        ),
        _buildDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Your CV',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              GestureDetector(
                onTap: () => _switchState(AccountSettingState.view),
                child: const Icon(Icons.close, size: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Upload Box
        GestureDetector(
          onTap: _pickCV,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: DottedBorder(
              options: RectDottedBorderOptions(
                color: AppColors.primary,
                strokeWidth: 2.w,
                dashPattern: const [10, 8],
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/image-upload.svg',
                      width: 32.w,
                      height: 32.w,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Click to upload CV',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Max. File Size: 10MB',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.text,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool autofocus = false,
  }) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool visible,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !visible,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: GestureDetector(
          onTap: onToggle,
          child: Icon(
            visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey,
            size: 20,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildActionButtons({
    required VoidCallback onCancel,
    required VoidCallback onSave,
  }) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              side: BorderSide(color: Colors.grey.withOpacity(0.4)),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Change Password',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
