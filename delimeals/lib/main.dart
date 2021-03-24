import 'package:flutter/material.dart';

import './screens/categories_screen.dart';
import './screens/category_meals_screen.dart';
import './screens/meal_detail_screen.dart';
import './screens/tabs_screen.dart';
import './screens/filters_screen.dart';
import './dummy_data.dart';
import './models/meal.dart';
import './models/filters.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Meal> _displayedMeals = DUMMY_MEALS;
  List<Meal> _favoriteMeals = [];

  Filters _filters = Filters(
    gluten: false,
    lactose: false,
    vegetarian: false,
    vegan: false,
  );

  void _setFilters(Filters filterData) {
    _filters = filterData;

    setState(() {
      _displayedMeals = DUMMY_MEALS.where((meal) {
        if (_filters.gluten && !meal.isGlutenFree) return false;
        if (_filters.lactose && !meal.isLactoseFree) return false;
        if (_filters.vegetarian && !meal.isVegetarian) return false;
        if (_filters.vegan && !meal.isVegan) return false;
        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String mealId) {
    final existingMealIndex =
        _favoriteMeals.indexWhere((meal) => meal.id == mealId);
    if (existingMealIndex > -1) {
      _favoriteMeals.removeAt(existingMealIndex);
    } else {
      _favoriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
    }
    setState(() {});
  }

  bool _isFavorite(String mealId) {
    return _favoriteMeals.any((meal) => meal.id == mealId);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'DeliMeals',
        theme: ThemeData(
            primarySwatch: Colors.pink,
            accentColor: Colors.amber,
            canvasColor: const Color.fromRGBO(255, 254, 229, 1),
            fontFamily: 'Raleway',
            textTheme: ThemeData.light().textTheme.copyWith(
                bodyText2: TextStyle(
                  color: const Color.fromRGBO(20, 51, 51, 1),
                ),
                bodyText1: TextStyle(
                  color: const Color.fromRGBO(20, 51, 51, 1),
                ),
                headline6: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoCondensed',
                ))),
        // home: CategoriesScreen(),
        initialRoute: '/', // Default is already `/`.
        routes: {
          '/': (ctx) => TabsScreen(_favoriteMeals),
          CategoryMealsScreen.routeName: (ctx) =>
              CategoryMealsScreen(_displayedMeals),
          MealDetailScreen.routeName: (ctx) =>
              MealDetailScreen(_toggleFavorite, _isFavorite),
          FiltersScreen.routeName: (ctx) =>
              FiltersScreen(_filters, _setFilters),
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (BuildContext context) => CategoriesScreen(),
        ),
      );
}
