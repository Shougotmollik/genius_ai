class Ingredient {
  final int? id;
  final String? name;
  final int? category;
  final String? categoryName;
  final String? unit;
  final String? pricePerUnit;
  final double? currentStock;
  final double? minimumStock;
  final String? status;
  final String? approvalStatus;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;

  Ingredient({
    this.id,
    this.name,
    this.category,
    this.categoryName,
    this.unit,
    this.pricePerUnit,
    this.currentStock,
    this.minimumStock,
    this.status,
    this.approvalStatus,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      categoryName: json['category_name'],
      unit: json['unit'],
      pricePerUnit: json['price_per_unit'],
      currentStock: json['current_stock'] != null
          ? (json['current_stock'] as num).toDouble()
          : null,
      minimumStock: json['minimum_stock'] != null
          ? (json['minimum_stock'] as num).toDouble()
          : null,
      status: json['status'],
      approvalStatus: json['approval_status'],
      createdBy: json['created_by'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedBy: json['updated_by'],
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "category": category,
      "category_name": categoryName,
      "unit": unit,
      "price_per_unit": pricePerUnit,
      "current_stock": currentStock,
      "minimum_stock": minimumStock,
      "status": status,
      "approval_status": approvalStatus,
      "created_by": createdBy,
      "created_at": createdAt?.toIso8601String(),
      "updated_by": updatedBy,
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}
