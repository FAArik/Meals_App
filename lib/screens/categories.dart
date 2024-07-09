import 'package:flutter/material.dart';
import 'package:flutter_internals/data/dummy_data.dart';
import 'package:flutter_internals/models/category.dart';
import 'package:flutter_internals/models/meal.dart';
import 'package:flutter_internals/screens/meals.dart';
import 'package:flutter_internals/widgets/category_grid_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeails});

  final List<Meal> availableMeails;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filtered = widget.availableMeails
        .where((el) => el.categories.contains(category.id))
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          meals: filtered,
          title: category.title,
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
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) => Padding(
            padding:
                EdgeInsets.only(top: 100 - _animationController.value * 100),
            child: child,
          ),
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
      ),
    );
  }
}
