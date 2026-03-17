import 'package:genius_ai/model/supplier.dart';

class SupplierOverview {
  final String? message;
  final SupplierOverviewSummary? summary;
  final int? count;
  final List<Supplier>? data;

  SupplierOverview({this.message, this.summary, this.count, this.data});

  factory SupplierOverview.fromJson(Map<String, dynamic> json) =>
      SupplierOverview(
        message: json["message"],
        summary: json["summary"] == null
            ? null
            : SupplierOverviewSummary.fromJson(json["summary"]),
        count: json["count"],
        data: json["data"] == null
            ? null
            : List<Supplier>.from(
                json["data"].map((x) => Supplier.fromJson(x)),
              ),
      );
}

class SupplierOverviewSummary {
  final int activeSupplier;
  final int priceAlertSupplier;

  SupplierOverviewSummary({
    required this.activeSupplier,
    required this.priceAlertSupplier,
  });

  factory SupplierOverviewSummary.fromJson(Map<String, dynamic> json) =>
      SupplierOverviewSummary(
        activeSupplier: json["active_suppliers"] ?? 0,
        priceAlertSupplier: json["price_alerts"] ?? 0,
      );
}
