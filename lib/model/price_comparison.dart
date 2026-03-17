class SupplierPriceComparison {
  final String productName;
  final String bestPrice;
  final List<SupplierInfo> suppliers;

  SupplierPriceComparison({
    required this.productName,
    required this.bestPrice,
    required this.suppliers,
  });

  factory SupplierPriceComparison.fromJson(Map<String, dynamic> json) {
    return SupplierPriceComparison(
      productName: json['product_name'] ?? '',
      bestPrice: json['best_price'] ?? '0.00',
      suppliers: (json['suppliers'] as List)
          .map((i) => SupplierInfo.fromJson(i))
          .toList(),
    );
  }
}

class SupplierInfo {
  final int supplierId;
  final String supplierName;
  final String categoryName;
  final String latestPrice;
  final String unit;
  final DateTime purchaseDate;
  final bool isBestPrice;

  SupplierInfo({
    required this.supplierId,
    required this.supplierName,
    required this.categoryName,
    required this.latestPrice,
    required this.unit,
    required this.purchaseDate,
    required this.isBestPrice,
  });

  factory SupplierInfo.fromJson(Map<String, dynamic> json) {
    return SupplierInfo(
      supplierId: json['supplier_id'] ?? 0,
      supplierName: json['supplier_name'] ?? '',
      categoryName: json['category_name'] ?? '',
      latestPrice: json['latest_price'] ?? '0.00',
      unit: json['unit'] ?? '',
      purchaseDate: DateTime.parse(
        json['purchase_date'] ?? DateTime.now().toString(),
      ),
      isBestPrice: json['is_best_price'] ?? false,
    );
  }
}
