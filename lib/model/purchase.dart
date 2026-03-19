class Purchase {
  final int? id;
  final int? supplierId;
  final String? supplierName;
  final String? productName;
  final String? categoryName;
  final String? unit;
  final String? price;
  final String? quantity;
  final DateTime? purchaseDate;
  final bool? isSpecial;
  final String? approvalStatus;
  final String? approvedBy;
  final String? approvedByName;
  final DateTime? approvedAt;
  final dynamic rejectedBy;
  final dynamic rejectedByName;
  final dynamic rejectedAt;
  final String? rejectionReason;
  final dynamic productFile;
  final dynamic reportFile;
  final String? remarks;
  final String? outletType;
  final String? createdBy;
  final String? createdByName;
  final String? updatedBy;
  final String? updatedByName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Purchase({
    this.id,
    this.supplierId,
    this.supplierName,
    this.productName,
    this.categoryName,
    this.unit,
    this.price,
    this.quantity,
    this.purchaseDate,
    this.isSpecial,
    this.approvalStatus,
    this.approvedBy,
    this.approvedByName,
    this.approvedAt,
    this.rejectedBy,
    this.rejectedByName,
    this.rejectedAt,
    this.rejectionReason,
    this.productFile,
    this.reportFile,
    this.remarks,
    this.outletType,
    this.createdBy,
    this.createdByName,
    this.updatedBy,
    this.updatedByName,
    this.createdAt,
    this.updatedAt,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
    id: json["id"],
    supplierId: json["supplier_id"],
    supplierName: json["supplier_name"],
    productName: json["product_name"],
    categoryName: json["category_name"],
    unit: json["unit"],
    price: json["price"],
    quantity: json["quantity"],
    purchaseDate: json["purchase_date"] == null
        ? null
        : DateTime.parse(json["purchase_date"]),
    isSpecial: json["is_special"],
    approvalStatus: json["approval_status"],
    approvedBy: json["approved_by"],
    approvedByName: json["approved_by_name"],
    approvedAt: json["approved_at"] == null
        ? null
        : DateTime.parse(json["approved_at"]),
    rejectedBy: json["rejected_by"],
    rejectedByName: json["rejected_by_name"],
    rejectedAt: json["rejected_at"],
    rejectionReason: json["rejection_reason"],
    productFile: json["product_file"],
    reportFile: json["report_file"],
    remarks: json["remarks"],
    outletType: json["outlet_type"],
    createdBy: json["created_by"],
    createdByName: json["created_by_name"],
    updatedBy: json["updated_by"],
    updatedByName: json["updated_by_name"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );
}
