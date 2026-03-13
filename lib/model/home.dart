class HomeData {
  final int? totalRecipeCount;
  final int? lowStockIngredientCount;
  final double? averageFoodCost;
  final List<HomeRecipe>? recentRecipes;

  HomeData({
    this.totalRecipeCount,
    this.lowStockIngredientCount,
    this.averageFoodCost,
    this.recentRecipes,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
    totalRecipeCount: json["total_recipe_count"],
    lowStockIngredientCount: json["low_stock_ingredient_count"],
    averageFoodCost: json["average_food_cost"]?.toDouble(),
    recentRecipes: json["recent_recipes"] == null
        ? []
        : List<HomeRecipe>.from(
            json["recent_recipes"]!.map((x) => HomeRecipe.fromJson(x)),
          ),
  );
}

class HomeRecipe {
  final int? id;
  final String? name;
  final String? description;
  final double? totalCost;
  final DateTime? createdAt;

  HomeRecipe({
    this.id,
    this.name,
    this.description,
    this.totalCost,
    this.createdAt,
  });

  factory HomeRecipe.fromJson(Map<String, dynamic> json) => HomeRecipe(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    totalCost: json["total_cost"]?.toDouble(),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );
}
