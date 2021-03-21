import 'package:flutter/material.dart';

import './screens/categories_screen.dart';
import './screens/category_meals_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
          '/': (ctx) => CategoriesScreen(),
          CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(),
        },
      );
}
