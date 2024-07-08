import 'package:flutter/material.dart';
import 'package:flutter_internals/models/meal.dart';
import 'package:flutter_internals/screens/categories.dart';
import 'package:flutter_internals/screens/meals.dart';
import 'package:flutter_internals/widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Meal> _favorites = [];

  void _setScreen(String identifier) {
    if (identifier == "filters") {
    } else {
      Navigator.of(context).pop();
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
    Widget activepage = CategoriesScreen(
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
