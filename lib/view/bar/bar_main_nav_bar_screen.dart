import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/view/bar/chatbot/bar_ai_chatbot_screen.dart';
import 'package:genius_ai/view/bar/home/bar_home_screen.dart';
import 'package:genius_ai/view/bar/profile/bar_profile_screen.dart';
import 'package:genius_ai/view/bar/supplier/bar_supplier_screen.dart';
import 'package:genius_ai/view/bar/upload/bar_upload_screen.dart';

class BarMainNavBarScreen extends StatefulWidget {
  const BarMainNavBarScreen({super.key});

  @override
  State<BarMainNavBarScreen> createState() => _BarMainNavBarScreenState();
}

class _BarMainNavBarScreenState extends State<BarMainNavBarScreen> {
  int _selectedIndex = 0;

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      BarHomeScreen(onProfileTap: () => changeTab(4)),
      BarAiChatbotScreen(),
      BarUploadScreen(),
      BarSupplierScreen(),
      BarProfileScreen(),
    ];
    return Scaffold(
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
    );
  }
}
