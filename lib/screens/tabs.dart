import 'package:flutter/material.dart';
import 'package:flutter_internals/models/meal.dart';
import 'package:flutter_internals/screens/categories.dart';
import 'package:flutter_internals/screens/meals.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Meal> _favorites = [];

  _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favorites.contains(meal);
    if (isExisting)
      _favorites.remove(meal);
    else
      _favorites.add(meal);
  }

  int _selectedPageIndex = 0;
  void _selectPage(int pageIndex) {
    setState(() {
      _selectedPageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activepage = const CategoriesScreen();
    var activePageTitle = "Categories";
    if (_selectedPageIndex == 1) {
      activepage = const MealsScreen(meals: []);
      activePageTitle = "Your Favorites";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
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
