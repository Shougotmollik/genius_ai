class IngredientModel {
  final String name;
  final String price;
  final String currentStock;
  final String minimumStock;
  final String category;
  final String status;
  final bool isMissing;

  IngredientModel({
    required this.name,
    required this.price,
    required this.currentStock,
    required this.minimumStock,
    required this.category,
    required this.status,
    required this.isMissing,
  });
}
