import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/view/widgets/delete_dialog_widget.dart';

// Note: Ensure these imports match your actual project structure
// import 'package:genius_ai/config/theme/app_colors.dart';

class BarLeaveHistoryScreen extends StatefulWidget {
  const BarLeaveHistoryScreen({super.key});

  @override
  State<BarLeaveHistoryScreen> createState() => _BarLeaveHistoryScreenState();
}

class _BarLeaveHistoryScreenState extends State<BarLeaveHistoryScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              _buildAppBar(context),
              SizedBox(height: 24.h),
              // Tab Bar
              Row(
                children: [
                  _buildTab("All", 0),
                  _buildTab("Upcoming", 1),
                  _buildTab("Finished", 2),
                ],
              ),
              SizedBox(height: 20.h),
              // Content List
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 20.h),
                  children: const [
                    LeaveRequestCard(
                      status: "Pending",
                      statusColor: Color(0xFFFEF3D7),
                      statusTextColor: Color(0xFFF59E0B),
                      type: "Sick Leave",
                      dateRange: "20 Dec, 2025 - 20 Dec, 2025",
                    ),
                    LeaveRequestCard(
                      status: "Approved",
                      statusColor: Color(0xFFE6F4EA),
                      statusTextColor: Color(0xFF34A853),
                      type: "Sick Leave",
                      dateRange: "20 Dec, 2025 - 20 Dec, 2025",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    bool isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedIndex = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.blue : Colors.grey.shade200,
                width: 2.w,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.blue : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            "My Leave Requests",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}

class LeaveRequestCard extends StatelessWidget {
  final String status;
  final Color statusColor;
  final Color statusTextColor;
  final String type;
  final String dateRange;

  const LeaveRequestCard({
    super.key,
    required this.status,
    required this.statusColor,
    required this.statusTextColor,
    required this.type,
    required this.dateRange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.25),
            blurRadius: 16.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusTextColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      // showDialog(
                      //   context: context,
                      //   barrierDismissible: false,
                      //   builder: (context) => const BarEditMenuDialog(),
                      // );
                    },
                    child: _iconButton(
                      bgColor: const Color(0xffF0B100).withValues(alpha: 0.2),
                      icon: "assets/icons/pen_edit.svg",
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return DeleteDialogWidget(
                            title: "Are you sure you want to delete it?",
                          );
                        },
                      );
                    },
                    child: _iconButton(
                      bgColor: const Color(0xffFAE9E9),
                      icon: "assets/icons/delete.svg",
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            type,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            dateRange,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
          ),
          SizedBox(height: 8.h),
          Text(
            "Lorem ipsum dolor sit amet consectetur. Faucibus quisque dolor imperdiet pellentesque malesuada cursus volutpat tincidunt.",
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey.shade500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton({required Color bgColor, required String icon}) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: SvgPicture.asset(icon, height: 18.h, width: 18.w),
    );
  }
}
