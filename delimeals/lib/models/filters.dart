import 'package:flutter/foundation.dart';

class Filters {
  final bool gluten;
  final bool lactose;
  final bool vegetarian;
  final bool vegan;

  const Filters({
    @required this.gluten,
    @required this.lactose,
    @required this.vegetarian,
    @required this.vegan,
  });
}
