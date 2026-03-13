import 'package:genius_ai/model/menu.dart';

class MenuRequest {
  final String? message;
  final Summary? summary;
  final int? count;
  final int? totalPages;
  final int? currentPage;
  final int? pageSize;
  final List<Menu>? data;

  MenuRequest({
    this.message,
    this.summary,
    this.count,
    this.totalPages,
    this.currentPage,
    this.pageSize,
    this.data,
  });

  factory MenuRequest.fromJson(Map<String, dynamic> json) {
    return MenuRequest(
      message: json['message'],
      summary: json['summary'] != null
          ? Summary.fromJson(json['summary'])
          : null,
      count: json['count'],
      totalPages: json['total_pages'],
      currentPage: json['current_page'],
      pageSize: json['page_size'],
      data: json['data'] != null
          ? List<Menu>.from(json['data'].map((x) => Menu.fromJson(x)))
          : null,
    );
  }
}

class Summary {
  final int? approved;
  final int? pending;
  final int? rejected;

  Summary({this.approved, this.pending, this.rejected});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      approved: json['approved'],
      pending: json['pending'],
      rejected: json['rejected'],
    );
  }
}

// class MenuData {
//   final int? id;
//   final String? name;
//   final String? menuType;
//   final String? outletType;
//   final String? totalCost;
//   final String? approvalStatus;
//   final String? approvedBy;
//   final String? approvedByName;
//   final DateTime? approvedAt;
//   final String? rejectedBy;
//   final String? rejectedByName;
//   final DateTime? rejectedAt;
//   final String? rejectionReason;
//   final String? createdBy;
//   final String? createdByName;
//   final String? updatedBy;
//   final String? updatedByName;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final List<Dish>? dishes;

//   MenuData({
//     this.id,
//     this.name,
//     this.menuType,
//     this.outletType,
//     this.totalCost,
//     this.approvalStatus,
//     this.approvedBy,
//     this.approvedByName,
//     this.approvedAt,
//     this.rejectedBy,
//     this.rejectedByName,
//     this.rejectedAt,
//     this.rejectionReason,
//     this.createdBy,
//     this.createdByName,
//     this.updatedBy,
//     this.updatedByName,
//     this.createdAt,
//     this.updatedAt,
//     this.dishes,
//   });

//   factory MenuData.fromJson(Map<String, dynamic> json) {
//     return MenuData(
//       id: json['id'],
//       name: json['name'],
//       menuType: json['menu_type'],
//       outletType: json['outlet_type'],
//       totalCost: json['total_cost'],
//       approvalStatus: json['approval_status'],
//       approvedBy: json['approved_by'],
//       approvedByName: json['approved_by_name'],
//       approvedAt: json['approved_at'] != null
//           ? DateTime.parse(json['approved_at'])
//           : null,
//       rejectedBy: json['rejected_by'],
//       rejectedByName: json['rejected_by_name'],
//       rejectedAt: json['rejected_at'] != null
//           ? DateTime.parse(json['rejected_at'])
//           : null,
//       rejectionReason: json['rejection_reason'],
//       createdBy: json['created_by'],
//       createdByName: json['created_by_name'],
//       updatedBy: json['updated_by'],
//       updatedByName: json['updated_by_name'],
//       createdAt: json['created_at'] != null
//           ? DateTime.parse(json['created_at'])
//           : null,
//       updatedAt: json['updated_at'] != null
//           ? DateTime.parse(json['updated_at'])
//           : null,
//       dishes: json['dishes'] != null
//           ? List<Dish>.from(json['dishes'].map((x) => Dish.fromJson(x)))
//           : null,
//     );
//   }
// }
