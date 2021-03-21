import 'package:flutter/material.dart';

import '../dummy_data.dart';
import '../widgets/meal_item.dart';

class CategoryMealsScreen extends StatelessWidget {
  static const routeName = '/category-meals';
  // final String id;
  // final String title;

  // const CategoryMealsScreen(this.id, this.title);

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final categoryId = routeArgs['id'];
    final categoryTitle = routeArgs['title'];
    final categoryMeals = DUMMY_MEALS
        .where((meal) => meal.categories.contains(categoryId))
        .toList();

    return Scaffold(
        appBar: AppBar(
          title: Text(categoryTitle),
        ),
        body: ListView.builder(
          itemBuilder: (ctx, idx) => MealItem(
              id: categoryMeals[idx].id,
              title: categoryMeals[idx].title,
              imageUrl: categoryMeals[idx].imageUrl,
              affordability: categoryMeals[idx].affordability,
              complexity: categoryMeals[idx].complexity,
              duration: categoryMeals[idx].duration),
          itemCount: categoryMeals.length,
        ));
  }
}
