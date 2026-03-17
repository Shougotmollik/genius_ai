class SupplierAvailableProduct {
  final String message;
  final List<String> data;

  SupplierAvailableProduct({required this.message, required this.data});

  factory SupplierAvailableProduct.fromJson(Map<String, dynamic> json) {
    return SupplierAvailableProduct(
      message: json['message'] ?? '',
      data: List<String>.from(json['data'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'data': data};
  }
}
