import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/controller/user_controller.dart';
import 'package:genius_ai/view/widgets/delete_dialog_widget.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RestaurantLeaveHistoryScreen extends StatefulWidget {
  const RestaurantLeaveHistoryScreen({super.key});

  @override
  State<RestaurantLeaveHistoryScreen> createState() =>
      _RestaurantLeaveHistoryScreenState();
}

class _RestaurantLeaveHistoryScreenState
    extends State<RestaurantLeaveHistoryScreen> {
  int selectedIndex = 0;
  final UserController controller = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    // Fetch data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getLeaveRequest();
    });
  }

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
                  _buildTab("Pending", 1),
                  _buildTab("Approved", 2),
                ],
              ),
              SizedBox(height: 20.h),

              // Content List - Expanded must be a direct child of Column
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Skeletonizer(
                      enabled: true,
                      child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) => LeaveRequestCard(
                          status: "Pending",
                          type: "Loading Type",
                          startDate: '01/01/2026',
                          endDate: '01/01/2026',
                          reason: 'Loading reason text here...',
                          onEdit: () {},
                        ),
                      ),
                    );
                  }

                  // Filter the leave list
                  final filteredList = controller.leaveList.where((leave) {
                    if (selectedIndex == 0) return true;
                    if (selectedIndex == 1) {
                      return leave.status?.toUpperCase() == "PENDING";
                    }
                    if (selectedIndex == 2) {
                      return leave.status?.toUpperCase() == "APPROVED";
                    }
                    return true;
                  }).toList();

                  if (filteredList.isEmpty) {
                    return Center(
                      child: Text(
                        "No leave requests found.",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => controller.getLeaveRequest(),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 20.h),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final leave = filteredList[index];
                        return LeaveRequestCard(
                          status:
                              leave.statusDisplay ?? leave.status ?? "Pending",
                          type:
                              leave.leaveTypeDisplay ??
                              leave.leaveType ??
                              "Leave",
                          startDate: leave.startDate ?? '',
                          endDate: leave.endDate ?? '',
                          reason: leave.reason ?? '',
                          onEdit: () {
                            Get.toNamed(
                              RouteNames.barEditLeaveRequest,
                              arguments: leave,
                            );
                          },
                        );
                      },
                    ),
                  );
                }),
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
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Icon(Icons.arrow_back, size: 20),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            "My Leave Requests",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class LeaveRequestCard extends StatelessWidget {
  final String status;
  final String type;
  final String startDate;
  final String endDate;
  final String reason;
  final VoidCallback onEdit;

  const LeaveRequestCard({
    super.key,
    required this.status,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic status colors
    final bool isPending = status.toLowerCase() == "pending";
    final bool isApproved = status.toLowerCase() == "approved";

    final Color statusBg = isPending
        ? const Color(0xFFFEF3D7)
        : isApproved
        ? const Color(0xFFE6F4EA)
        : const Color(0xFFFAE9E9);

    final Color statusText = isPending
        ? const Color(0xFFF59E0B)
        : isApproved
        ? const Color(0xFF34A853)
        : const Color(0xFFD93025);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
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
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusText,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: [
                  _actionButton(
                    onTap: onEdit,
                    bgColor: const Color(0xffF0B100).withOpacity(0.1),
                    icon: "assets/icons/pen_edit.svg",
                  ),
                  SizedBox(width: 10.w),
                  _actionButton(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => DeleteDialogWidget(
                          title: "Are you sure you want to delete this?",
                        ),
                      );
                    },
                    bgColor: const Color(0xffFAE9E9),
                    icon: "assets/icons/delete.svg",
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            type,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.h),
          Text(
            "$startDate - $endDate",
            style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
          ),
          SizedBox(height: 8.h),
          Text(
            reason,
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

  Widget _actionButton({
    required VoidCallback onTap,
    required Color bgColor,
    required String icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: SvgPicture.asset(icon, height: 16.h, width: 16.w),
      ),
    );
  }
}
