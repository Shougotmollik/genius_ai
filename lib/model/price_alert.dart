class PriceAlert {
  final int supplierId;
  final String supplierName;
  final String productName;
  final String categoryName;
  final double previousPrice;
  final double currentPrice;
  final double changeAmount;
  final double changePercentage;
  final String alertType;
  final DateTime purchaseDate;
  final String unit;

  PriceAlert({
    required this.supplierId,
    required this.supplierName,
    required this.productName,
    required this.categoryName,
    required this.previousPrice,
    required this.currentPrice,
    required this.changeAmount,
    required this.changePercentage,
    required this.alertType,
    required this.purchaseDate,
    required this.unit,
  });

  bool get isIncrease => alertType == 'increase';

  factory PriceAlert.fromJson(Map<String, dynamic> json) {
    return PriceAlert(
      supplierId: json['supplier_id'] ?? 0,
      supplierName: json['supplier_name'] ?? '',
      productName: json['product_name'] ?? '',
      categoryName: json['category_name'] ?? '',
      previousPrice: double.tryParse(json['previous_price'].toString()) ?? 0.0,
      currentPrice: double.tryParse(json['current_price'].toString()) ?? 0.0,
      changeAmount: double.tryParse(json['change_amount'].toString()) ?? 0.0,
      changePercentage:
          double.tryParse(json['change_percentage'].toString()) ?? 0.0,
      alertType: json['alert_type'] ?? '',
      purchaseDate: DateTime.parse(
        json['purchase_date'] ?? DateTime.now().toString(),
      ),
      unit: json['unit'] ?? '',
    );
  }
}
