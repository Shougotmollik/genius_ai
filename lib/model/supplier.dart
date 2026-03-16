class Supplier {
  final int? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final String? contractStartDate;
  final String? contractEndDate;
  final String? notes;
  final String? rating;
  final bool? isActive;
  final String? outletType;
  final String? approvalStatus;
  final String? approvedBy;
  final String? approvedByName;
  final DateTime? approvedAt;
  final String? rejectedBy;
  final String? rejectedByName;
  final DateTime? rejectedAt;
  final String? rejectionReason;
  final String? createdBy;
  final String? createdByName;
  final String? updatedBy;
  final String? updatedByName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Supplier({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.contractStartDate,
    this.contractEndDate,
    this.notes,
    this.rating,
    this.isActive,
    this.outletType,
    this.approvalStatus,
    this.approvedBy,
    this.approvedByName,
    this.approvedAt,
    this.rejectedBy,
    this.rejectedByName,
    this.rejectedAt,
    this.rejectionReason,
    this.createdBy,
    this.createdByName,
    this.updatedBy,
    this.updatedByName,
    this.createdAt,
    this.updatedAt,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      contractStartDate: json['contract_start_date'] as String?,
      contractEndDate: json['contract_end_date'] as String?,
      notes: json['notes'] as String?,
      rating: json['rating'] as String?,
      isActive: json['is_active'] as bool?,
      outletType: json['outlet_type'] as String?,
      approvalStatus: json['approval_status'] as String?,
      approvedBy: json['approved_by'] as String?,
      approvedByName: json['approved_by_name'] as String?,
      approvedAt: json['approved_at'] != null ? DateTime.tryParse(json['approved_at']) : null,
      rejectedBy: json['rejected_by'] as String?,
      rejectedByName: json['rejected_by_name'] as String?,
      rejectedAt: json['rejected_at'] != null ? DateTime.tryParse(json['rejected_at']) : null,
      rejectionReason: json['rejection_reason'] as String?,
      createdBy: json['created_by'] as String?,
      createdByName: json['created_by_name'] as String?,
      updatedBy: json['updated_by'] as String?,
      updatedByName: json['updated_by_name'] as String?,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }
}