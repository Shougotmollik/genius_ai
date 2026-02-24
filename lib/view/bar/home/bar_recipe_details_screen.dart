import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/view/widgets/primary_button.dart';

class Ingredient {
  final String name;
  final String quantity;
  final String price;

  const Ingredient({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

class BarRecipeDetailsScreen extends StatelessWidget {
  const BarRecipeDetailsScreen({super.key});

  static const List<Ingredient> ingredients = [
    Ingredient(name: 'Pizza dough', quantity: '200gm', price: '\$20'),
    Ingredient(name: 'Tomato sauce', quantity: '200gm', price: '\$20'),
    Ingredient(name: 'Mozzarella cheese', quantity: '200gm', price: '\$20'),
    Ingredient(name: 'chicken', quantity: '200gm', price: '\$20'),
    Ingredient(name: 'Bell peppers', quantity: '200gm', price: '\$20'),
    Ingredient(name: 'Onions', quantity: '200gm', price: '\$20'),
    Ingredient(name: 'Pizza dough', quantity: '200gm', price: '\$20'),
    Ingredient(name: 'Pizza dough', quantity: '200gm', price: '\$20'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar with back button
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.asset(
                        "assets/image/mocktail.jpg",
                        height: 120.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      'Mocktail',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'Traditional Italian pizza did not originally include chicken. Classic Italian pizzas focused on simple ingredients like dough, tomato, olive oil, and cheese.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Ingredients header
                    Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Ingredients list
                    ...ingredients.map(
                      (ingredient) => Column(
                        children: [
                          IngredientRow(ingredient: ingredient),
                          Divider(height: 1.h, color: Color(0xFF_F4F4F4)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Total Ingredient Cost
                    SummaryRow(
                      label: 'Total Ingredient Cost:',
                      value: '\$200',
                      isBold: true,
                    ),

                    const Divider(height: 1, color: Colors.black12),

                    // Selling Cost
                    SummaryRow(
                      label: 'Selling Cost:',
                      value: '\$200',
                      isBold: true,
                    ),

                    const SizedBox(height: 8),

                    // Food Cost highlighted row
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF_E6F4FF),
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Food Cost:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '\$200',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                    CustomElevatedButton(btnText: 'Download', onTap: () {}),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IngredientRow extends StatelessWidget {
  final Ingredient ingredient;

  const IngredientRow({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  ingredient.name,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  ingredient.quantity,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              Text(
                ingredient.price,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
