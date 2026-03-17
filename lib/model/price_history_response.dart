class PriceHistoryResponse {
  final String message;
  final String productName;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> labels;
  final int count;
  final List<SupplierData> data;

  PriceHistoryResponse({
    required this.message,
    required this.productName,
    required this.startDate,
    required this.endDate,
    required this.labels,
    required this.count,
    required this.data,
  });

  factory PriceHistoryResponse.fromJson(Map<String, dynamic> json) {
    return PriceHistoryResponse(
      message: json['message'] ?? '',
      productName: json['product_name'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      labels: List<String>.from(json['labels'] ?? []),
      count: json['count'] ?? 0,
      data: (json['data'] as List)
          .map((item) => SupplierData.fromJson(item))
          .toList(),
    );
  }
}

class SupplierData {
  final int supplierId;
  final String supplierName;
  final String unit;
  final double latestPrice;
  final double previousPrice;
  final double changeAmount;
  final double changePercentage;
  final String trend;
  final List<double> prices;

  SupplierData({
    required this.supplierId,
    required this.supplierName,
    required this.unit,
    required this.latestPrice,
    required this.previousPrice,
    required this.changeAmount,
    required this.changePercentage,
    required this.trend,
    required this.prices,
  });

  factory SupplierData.fromJson(Map<String, dynamic> json) {
    return SupplierData(
      supplierId: json['supplier_id'] ?? 0,
      supplierName: json['supplier_name'] ?? '',
      unit: json['unit'] ?? '',
      latestPrice: double.tryParse(json['latest_price'].toString()) ?? 0.0,
      previousPrice: double.tryParse(json['previous_price'].toString()) ?? 0.0,
      changeAmount: double.tryParse(json['change_amount'].toString()) ?? 0.0,
      changePercentage: (json['change_percentage'] as num).toDouble(),
      trend: json['trend'] ?? 'stable',
      prices: (json['prices'] as List)
          .map((p) => double.tryParse(p.toString()) ?? 0.0)
          .toList(),
    );
  }
}
