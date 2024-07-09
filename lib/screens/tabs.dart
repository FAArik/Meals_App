import 'package:flutter/material.dart';
import 'package:flutter_internals/providers/favorites_provider.dart';
import 'package:flutter_internals/providers/filters_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_internals/screens/categories.dart';
import 'package:flutter_internals/screens/filters.dart';
import 'package:flutter_internals/screens/meals.dart';
import 'package:flutter_internals/widgets/main_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  Future<void> _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == "filters") {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
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
    final availableMeals = ref.watch(filteredMealsProvider);

    Widget activepage = CategoriesScreen(
      availableMeails: availableMeals,
    );

    var activePageTitle = "Categories";
    if (_selectedPageIndex == 1) {
      final favoritesMeal = ref.watch(favoriteMealsProvider);
      activepage = MealsScreen(
        meals: favoritesMeal,
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
