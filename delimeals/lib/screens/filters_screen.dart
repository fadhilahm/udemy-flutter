import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';
import '../models/filters.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';

  final Filters filters;
  final Function saveFilters;

  const FiltersScreen(this.filters, this.saveFilters);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _isGlutenFree = false;
  var _isLactoseFree = false;
  var _isVegetarian = false;
  var _isVegan = false;

  @override
  initState() {
    super.initState();
    _isGlutenFree = widget.filters.gluten;
    _isLactoseFree = widget.filters.lactose;
    _isVegetarian = widget.filters.vegetarian;
    _isVegan = widget.filters.vegan;
  }

  Widget _buildSwitchListTile({
    @required String title,
    @required String description,
    @required bool currVal,
    @required Function updateValueHandler,
  }) =>
      SwitchListTile(
        title: Text(title),
        subtitle: Text(description),
        value: currVal,
        onChanged: updateValueHandler,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Filters'),
          actions: [
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  widget.saveFilters(
                    Filters(
                      gluten: _isGlutenFree,
                      lactose: _isLactoseFree,
                      vegetarian: _isVegetarian,
                      vegan: _isVegan,
                    ),
                  );
                })
          ],
        ),
        drawer: MainDrawer(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Adjust your meal selection.',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Expanded(
                child: ListView(
              children: [
                _buildSwitchListTile(
                  title: 'Gluten-free',
                  description: 'Only include gluten-free meals.',
                  currVal: _isGlutenFree,
                  updateValueHandler: (bool newVal) {
                    setState(() {
                      _isGlutenFree = newVal;
                    });
                  },
                ),
                _buildSwitchListTile(
                  title: 'Lactose-free',
                  description: 'Only include lactose-free meals.',
                  currVal: _isLactoseFree,
                  updateValueHandler: (bool newVal) {
                    setState(() {
                      _isLactoseFree = newVal;
                    });
                  },
                ),
                _buildSwitchListTile(
                  title: 'Vegetarian',
                  description: 'Only include vegetarian meals.',
                  currVal: _isVegetarian,
                  updateValueHandler: (bool newVal) {
                    setState(() {
                      _isVegetarian = newVal;
                    });
                  },
                ),
                _buildSwitchListTile(
                  title: 'Vegan',
                  description: 'Only include vegan meals.',
                  currVal: _isVegan,
                  updateValueHandler: (bool newVal) {
                    setState(() {
                      _isVegan = newVal;
                    });
                  },
                ),
              ],
            ))
          ],
        ));
  }
}
