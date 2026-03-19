import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/controller/notification_controller.dart';
import 'package:genius_ai/model/notification_model.dart';
import 'package:get/get.dart';

class RestaurantNotificationScreen extends StatefulWidget {
  const RestaurantNotificationScreen({super.key});

  @override
  State<RestaurantNotificationScreen> createState() =>
      _RestaurantNotificationScreenState();
}

class _RestaurantNotificationScreenState
    extends State<RestaurantNotificationScreen>
    with SingleTickerProviderStateMixin {
  final NotificationController controller = Get.find<NotificationController>();
  late TabController _tabController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
    // Fetch notifications when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getNotifications();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 20.h),

              // Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    _buildTab('All', 0),
                    const SizedBox(width: 24),
                    _buildTab('Unread', 1),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Notification List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildNotificationList(controller.notifications),
                      _buildNotificationList(
                        controller.notifications
                            .where((n) => !n.isRead)
                            .toList(),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? const Color(0xFF4A90E2)
                  : Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: isSelected ? 30 : 0,
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationModel> items) {
    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No notifications',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: items.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _NotificationCard(
          item: items[index],
          onTap: () {
            // handle tap, perhaps mark as read or navigate
          },
        );
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel item;
  final VoidCallback onTap;

  const _NotificationCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon instead of avatar since API doesn't provide avatarUrl
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications,
                color: Color(0xFF4A90E2),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                      ),
                      if (!item.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4A90E2),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(item.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.message,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
}
