import 'package:flutter/material.dart';
import 'package:flutter_internals/data/dummy_data.dart';
import 'package:flutter_internals/models/category.dart';
import 'package:flutter_internals/models/meal.dart';
import 'package:flutter_internals/screens/meals.dart';
import 'package:flutter_internals/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, required this.onToggleFavorite});

  final void Function(Meal meal) onToggleFavorite;

  void _selectCategory(BuildContext context, Category category) {
    final filtered =
        dummyMeals.where((el) => el.categories.contains(category.id)).toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          meals: filtered,
          title: category.title,
          onToggleFavorite: onToggleFavorite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick your category"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          children: [
            ///...availableCategories.map((category)=>CategoryGridItem(category: category)).toList(),
            for (final category in availableCategories)
              CategoryGridItem(
                category: category,
                onSelectCategory: () {
                  _selectCategory(context, category);
                },
              ),
          ],
        ),
      ),
    );
  }
}
