import 'package:flutter/material.dart';

import 'package:flutter_internals/providers/meals_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_internals/models/meal.dart';
import 'package:flutter_internals/screens/categories.dart';
import 'package:flutter_internals/screens/filters.dart';
import 'package:flutter_internals/screens/meals.dart';
import 'package:flutter_internals/widgets/main_drawer.dart';

const kInitialFilters = {
  Filters.vegan: false,
  Filters.vegetarian: false,
  Filters.glutenFree: false,
  Filters.lactoseFree: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  final List<Meal> _favorites = [];
  Map<Filters, bool> selectedFilters = kInitialFilters;
  Future<void> _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == "filters") {
      final res = await Navigator.of(context).push<Map<Filters, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilters: selectedFilters,
          ),
        ),
      );
      setState(() {
        selectedFilters = res ?? kInitialFilters;
      });
    }
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    setState(() {
      updateFavorites(meal);
    });
  }

  void updateFavorites(Meal meal) {
    final isExisting = _favorites.contains(meal);
    if (isExisting) {
      _favorites.remove(meal);
      _showInfoMessage("Removed from Favorites!");
    } else {
      _favorites.add(meal);
      _showInfoMessage("Marked as Favorite!");
    }
  }

  int _selectedPageIndex = 0;
  void _selectPage(int pageIndex) {
    setState(() {
      _selectedPageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final availableMeals = meals.where((meal) {
      if (selectedFilters[Filters.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (selectedFilters[Filters.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (selectedFilters[Filters.vegan]! && !meal.isVegan) {
        return false;
      }
      if (selectedFilters[Filters.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      return true;
    }).toList();
    Widget activepage = CategoriesScreen(
      availableMeails: availableMeals,
      onToggleFavorite: _toggleMealFavoriteStatus,
    );
    var activePageTitle = "Categories";
    if (_selectedPageIndex == 1) {
      activepage = MealsScreen(
        meals: _favorites,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = "Your Favorites";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activepage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
        onTap: (index) {
          _selectPage(index);
        },
      ),
    );
  }
}
