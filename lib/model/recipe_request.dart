
class RecipeRequestResponse {
  final String? message;
  final Summary? summary;
  final int? count;
  final int? totalPages;
  final int? currentPage;
  final int? pageSize;
  final List<RecipeRequest>? data;

  RecipeRequestResponse({
    this.message,
    this.summary,
    this.count,
    this.totalPages,
    this.currentPage,
    this.pageSize,
    this.data,
  });

  factory RecipeRequestResponse.fromJson(Map<String, dynamic> json) => RecipeRequestResponse(
    message: json["message"],
    summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
    count: json["count"],
    totalPages: json["total_pages"],
    currentPage: json["current_page"],
    pageSize: json["page_size"],
    data: json["data"] == null 
        ? null 
        : List<RecipeRequest>.from(json["data"].map((x) => RecipeRequest.fromJson(x))),
  );
}

class Summary {
  final int? approved;
  final int? pending;
  final int? rejected;

  Summary({this.approved, this.pending, this.rejected});

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    approved: json["approved"],
    pending: json["pending"],
    rejected: json["rejected"],
  );
}

class RecipeRequest {
  final int? id;
  final String? name;
  final int? avgTime;
  final String? instruction;
  final String? sellingCost;
  final String? totalCost;
  final String? approvalStatus;
  final String? approvedByName;
  final DateTime? approvedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Ingredient>? ingredients;

  RecipeRequest({
    this.id,
    this.name,
    this.avgTime,
    this.instruction,
    this.sellingCost,
    this.totalCost,
    this.approvalStatus,
    this.approvedByName,
    this.approvedAt,
    this.createdAt,
    this.updatedAt,
    this.ingredients,
  });

  factory RecipeRequest.fromJson(Map<String, dynamic> json) => RecipeRequest(
    id: json["id"],
    name: json["name"],
    avgTime: json["avg_time"],
    instruction: json["instruction"],
    sellingCost: json["selling_cost"],
    totalCost: json["total_cost"],
    approvalStatus: json["approval_status"],
    approvedByName: json["approved_by_name"],
    approvedAt: json["approved_at"] == null ? null : DateTime.parse(json["approved_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    ingredients: json["ingredients"] == null 
        ? null 
        : List<Ingredient>.from(json["ingredients"].map((x) => Ingredient.fromJson(x))),
  );
}

class Ingredient {
  final int? id;
  final String? ingredient;
  final String? quantity;
  final String? unit;
  final String? cost;

  Ingredient({this.id, this.ingredient, this.quantity, this.unit, this.cost});

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
    id: json["id"],
    ingredient: json["ingredient"],
    quantity: json["quantity"],
    unit: json["unit"],
    cost: json["cost"],
  );
}