import 'package:flutter/material.dart';

import '../widgets/meal_item.dart';
import '../models/meal.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Meal> favoriteMeals;

  const FavoritesScreen(this.favoriteMeals);

  @override
  Widget build(BuildContext context) => favoriteMeals.isEmpty
      ? Center(
          child: const Text(
            'This list is empty - Start adding your favorite Meal(s)!',
            textAlign: TextAlign.center,
          ),
        )
      : ListView.builder(
          itemBuilder: (ctx, idx) => MealItem(
            id: favoriteMeals[idx].id,
            title: favoriteMeals[idx].title,
            imageUrl: favoriteMeals[idx].imageUrl,
            affordability: favoriteMeals[idx].affordability,
            complexity: favoriteMeals[idx].complexity,
            duration: favoriteMeals[idx].duration,
          ),
          itemCount: favoriteMeals.length,
        );
}
