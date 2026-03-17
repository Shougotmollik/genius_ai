import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/view/restaurant/chatbot/restaurant_ai_chatbot_screen.dart';
import 'package:genius_ai/view/restaurant/home/restaurant_home_screen.dart';
import 'package:genius_ai/view/restaurant/profile/restaurant_profile_screen.dart';
import 'package:genius_ai/view/restaurant/supplier/restaurant_supplier_screen.dart';
import 'package:genius_ai/view/restaurant/upload/restaurant_upload_screen.dart';

class RestaurantMainNavBarScreen extends StatefulWidget {
  const RestaurantMainNavBarScreen({super.key});

  @override
  State<RestaurantMainNavBarScreen> createState() =>
      _RestaurantMainNavBarScreenState();
}

class _RestaurantMainNavBarScreenState
    extends State<RestaurantMainNavBarScreen> {
  int _selectedIndex = 0;
  DateTime? _lastBackPressed;

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handleBackLogic() async {
    if (_selectedIndex != 0) {
      setState(() => _selectedIndex = 0);
      return;
    }

    final now = DateTime.now();
    final isSecondPress =
        _lastBackPressed != null &&
        now.difference(_lastBackPressed!) < const Duration(seconds: 2);

    if (isSecondPress) {
      SystemNavigator.pop();
      return;
    }

    _lastBackPressed = now;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.exit_to_app_rounded, color: Colors.white, size: 20.sp),
            SizedBox(width: 10.w),
            Text(
              'Press back again to exit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        backgroundColor: const Color(0xFF323232),
        elevation: 6,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }

  final List<Map<String, String>> _navItems = [
    {'icon': 'assets/icons/home.svg', 'label': 'Home'},
    {'icon': 'assets/icons/chat.svg', 'label': 'Ai'},
    {'icon': 'assets/icons/upload.svg', 'label': 'Upload'},
    {'icon': 'assets/icons/suppiler.svg', 'label': 'Supplier'},
    {'icon': 'assets/icons/user.svg', 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      RestaurantHomeScreen(onProfileTap: () => changeTab(4)),
      RestaurantAiChatbotScreen(),
      RestaurantUploadScreen(),
      RestaurantSupplierScreen(),
      RestaurantProfileScreen(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBackLogic();
      },
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _screens),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            backgroundColor: AppColors.surface,
            onTap: (index) => setState(() => _selectedIndex = index),
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.black,
            selectedLabelStyle: TextStyle(
              color: AppColors.primary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            unselectedLabelStyle: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: List.generate(
              _navItems.length,
              (index) => BottomNavigationBarItem(
                label: _navItems[index]['label'],
                icon: SvgPicture.asset(
                  _navItems[index]['icon']!,
                  width: 24.w,
                  height: 24.w,
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  _navItems[index]['icon']!,
                  width: 24.w,
                  height: 24.w,
                  colorFilter: ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
