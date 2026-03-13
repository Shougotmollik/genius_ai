import 'package:genius_ai/model/dish.dart';

class Menu {
  final int? id;
  final String? name;
  final String? menuType;
  final String? outletType;
  final String? totalCost;
  final String? approvalStatus;
  final String? approvedByName;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final String? createdByName;
  final DateTime? createdAt;
  final String? createdBy;
  final List<Dish>? dishes;

  Menu({
    this.id,
    this.name,
    this.menuType,
    this.outletType,
    this.totalCost,
    this.approvalStatus,
    this.approvedByName,
    this.approvedAt,
    this.rejectionReason,
    this.createdByName,
    this.createdAt,
    this.dishes,
    this.createdBy,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    id: json["id"],
    name: json["name"],
    menuType: json["menu_type"],
    outletType: json["outlet_type"],
    totalCost: json["total_cost"],
    approvalStatus: json["approval_status"],
    approvedByName: json["approved_by_name"],
    approvedAt: json["approved_at"] == null
        ? null
        : DateTime.parse(json["approved_at"]),
    rejectionReason: json["rejection_reason"],
    createdByName: json["created_by_name"],
    createdBy: json["created_by"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    dishes: json["dishes"] == null
        ? null
        : List<Dish>.from(json["dishes"].map((x) => Dish.fromJson(x))),
  );
}
