import 'package:genius_ai/model/supplier.dart';

class SupplierRequest {
  final String? message;
  final SupplierRequestSummary? summary;
  final int? count;
  final List<Supplier>? data;

  SupplierRequest({this.message, this.summary, this.count, this.data});

  factory SupplierRequest.fromJson(Map<String, dynamic> json) =>
      SupplierRequest(
        message: json["message"],
        summary: json["summary"] == null
            ? null
            : SupplierRequestSummary.fromJson(json["summary"]),
        count: json["count"],
        data: json["data"] == null
            ? null
            : List<Supplier>.from(
                json["data"].map((x) => Supplier.fromJson(x)),
              ),
      );
}

class SupplierRequestSummary {
  final int? approved;
  final int? pending;

  SupplierRequestSummary({this.approved, this.pending});

  factory SupplierRequestSummary.fromJson(Map<String, dynamic> json) =>
      SupplierRequestSummary(
        approved: json["approved"],
        pending: json["pending"],
      );
}
