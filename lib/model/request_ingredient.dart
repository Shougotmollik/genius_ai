import 'package:genius_ai/model/ingredient.dart';

class IngredientResponse {
  String? message;
  Summary? summary;
  int? count;
  int? totalPages;
  int? currentPage;
  int? pageSize;
  List<Ingredient>? data;

  IngredientResponse({
    this.message,
    this.summary,
    this.count,
    this.totalPages,
    this.currentPage,
    this.pageSize,
    this.data,
  });

  IngredientResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    summary = json['summary'] != null
        ? Summary.fromJson(json['summary'])
        : null;
    count = json['count'];
    totalPages = json['total_pages'];
    currentPage = json['current_page'];
    pageSize = json['page_size'];

    if (json['data'] != null) {
      data = <Ingredient>[];
      json['data'].forEach((v) {
        data!.add(Ingredient.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    data['count'] = count;
    data['total_pages'] = totalPages;
    data['current_page'] = currentPage;
    data['page_size'] = pageSize;

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Summary {
  int? approved;
  int? pending;

  Summary({this.approved, this.pending});

  Summary.fromJson(Map<String, dynamic> json) {
    approved = json['approved'];
    pending = json['pending'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['approved'] = approved;
    data['pending'] = pending;
    return data;
  }
}
