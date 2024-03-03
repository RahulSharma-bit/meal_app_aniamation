import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_rp/screens/categories.dart';
import 'package:meal_rp/screens/filters.dart';
import 'package:meal_rp/screens/meals.dart';
import 'package:meal_rp/widgets/main_drawer.dart';
import 'package:meal_rp/providers/favorites_provider.dart';
import 'package:meal_rp/providers/filters_provider.dart';

const kIntialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegeterian: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int activePageIndex = 0;
  // Map<Filter, bool> _selectedFilters = kIntialFilters;

  void _setScreen(String identifier) async {
    if (identifier == 'filters') {
      Navigator.of(context).pop();
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
      // setState(() {
      //   _selectedFilters = result ?? kIntialFilters;
      // });
      // print(result);
    } else {
      Navigator.of(context).pop();
    }
  }

  void selectPage(int index) {
    setState(() {
      activePageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filtererdMealsProvider);

    String activePageTitle = "Categories";
    Widget content = CategoriesScreen(
      availableMeals: availableMeals,
    );

    if (activePageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      content = MealsScreen(
        meals: favoriteMeals,
      );
      activePageTitle = "Favorite's";
    }

    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      drawer: MainDrawer(
        onSelectScreen: (identifier) => _setScreen(identifier),
      ),
      body: content,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: activePageIndex,
          onTap: selectPage,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.set_meal), label: "Categories"),
            BottomNavigationBarItem(
                icon: Icon(Icons.star_border_purple500), label: "Favorite"),
          ]),
    );
  }
}
