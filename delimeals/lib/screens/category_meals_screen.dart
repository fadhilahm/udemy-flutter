import 'package:flutter/material.dart';

import '../widgets/meal_item.dart';
import '../dummy_data.dart';
import '../models/meal.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = '/category-meals';

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  String _categoryTitle;
  List<Meal> _categoryMeals;
  var _loadedInitData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loadedInitData) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      final categoryId = routeArgs['id'];
      _categoryTitle = routeArgs['title'];
      _categoryMeals = DUMMY_MEALS
          .where((meal) => meal.categories.contains(categoryId))
          .toList();
      _loadedInitData = true;
    }
  }

  void _removeItem(String id) {
    setState(() {
      _categoryMeals.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_categoryTitle),
        ),
        body: ListView.builder(
          itemBuilder: (ctx, idx) => MealItem(
            id: _categoryMeals[idx].id,
            title: _categoryMeals[idx].title,
            imageUrl: _categoryMeals[idx].imageUrl,
            affordability: _categoryMeals[idx].affordability,
            complexity: _categoryMeals[idx].complexity,
            duration: _categoryMeals[idx].duration,
            removeItem: _removeItem,
          ),
          itemCount: _categoryMeals.length,
        ));
  }
}
