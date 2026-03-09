class Recipe {
  final int? id;
  final String? name;
  final int? avgTime;
  final String? instruction;
  final String? sellingCost;
  final String? totalCost;
  final String? approvalStatus;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<RecipeIngredient>? ingredients;

  Recipe({
    this.id,
    this.name,
    this.avgTime,
    this.instruction,
    this.sellingCost,
    this.totalCost,
    this.approvalStatus,
    this.approvedBy,
    this.approvedAt,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json["id"],
    name: json["name"],
    avgTime: json["avg_time"],
    instruction: json["instruction"],
    sellingCost: json["selling_cost"],
    totalCost: json["total_cost"],
    approvalStatus: json["approval_status"],
    approvedBy: json["approved_by"],
    approvedAt: json["approved_at"] == null
        ? null
        : DateTime.parse(json["approved_at"]),
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    ingredients: json["ingredients"] == null
        ? null
        : List<RecipeIngredient>.from(
            json["ingredients"].map((x) => RecipeIngredient.fromJson(x)),
          ),
  );
}

class RecipeIngredient {
  final int? id;
  final String? ingredient;
  final String? quantity;
  final String? unit;
  final String? cost;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RecipeIngredient({
    this.id,
    this.ingredient,
    this.quantity,
    this.unit,
    this.cost,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) => RecipeIngredient(
    id: json["id"],
    ingredient: json["ingredient"],
    quantity: json["quantity"],
    unit: json["unit"],
    cost: json["cost"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );
}
