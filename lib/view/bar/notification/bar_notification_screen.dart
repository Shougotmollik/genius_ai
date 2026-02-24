import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationItem {
  final String title;
  final String time;
  final String description;
  final String avatarUrl;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.time,
    required this.description,
    required this.avatarUrl,
    this.isRead = false,
  });
}

class BarNotificationScreen extends StatefulWidget {
  const BarNotificationScreen({super.key});

  @override
  State<BarNotificationScreen> createState() => _BarNotificationScreenState();
}

class _BarNotificationScreenState extends State<BarNotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: 'Your recipe is accepted',
      time: 'Tuesday 2:00 PM',
      description: 'Recipe of chicken fry is approved',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      isRead: true,
    ),
    NotificationItem(
      title: 'Your leave request is approved',
      time: 'Tuesday 2:00 PM',
      description: 'you can have a break now',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      isRead: false,
    ),
    NotificationItem(
      title: 'Your Ingredients is accepted',
      time: 'Tuesday 2:00 PM',
      description: 'Your ingredient list is added',
      avatarUrl: 'https://i.pravatar.cc/150?img=33',
      isRead: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<NotificationItem> get _filteredNotifications {
    if (_selectedTab == 1) {
      return _notifications.where((n) => !n.isRead).toList();
    }
    return _notifications;
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
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildNotificationList(_notifications),
                    _buildNotificationList(
                      _notifications.where((n) => !n.isRead).toList(),
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

  Widget _buildNotificationList(List<NotificationItem> items) {
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
            setState(() {
              items[index].isRead = true;
            });
          },
        );
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem item;
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
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                item.avatarUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.grey),
                  );
                },
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
                    item.time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
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
}
