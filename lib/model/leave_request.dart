class LeaveRequest {
  final int? id;
  final String? userId;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? leaveType;
  final String? leaveTypeDisplay;
  final String? startDate;
  final String? endDate;
  final String? reason;
  final String? status;
  final String? statusDisplay;
  final DateTime? createdAt;

  LeaveRequest({
    this.id,
    this.userId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.leaveType,
    this.leaveTypeDisplay,
    this.startDate,
    this.endDate,
    this.reason,
    this.status,
    this.statusDisplay,
    this.createdAt,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return LeaveRequest();
    }

    return LeaveRequest(
      id: json['id'],
      userId: json['user_id'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      leaveType: json['leave_type'],
      leaveTypeDisplay: json['leave_type_display'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      reason: json['reason'],
      status: json['status'],
      statusDisplay: json['status_display'],
      // Safely parse DateTime only if the string exists
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}
