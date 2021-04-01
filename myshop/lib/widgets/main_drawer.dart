import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class MainDrawer extends StatelessWidget {
  List<Widget> buildDrawerItem({
    @required BuildContext context,
    @required String title,
    @required IconData icon,
    @required String routeName,
  }) {
    return [
      const Divider(),
      ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () => Navigator.of(context).pushReplacementNamed(routeName),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          AppBar(
            title: const Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          ...buildDrawerItem(
            context: context,
            title: 'Shop',
            icon: Icons.shop,
            routeName: '/',
          ),
          ...buildDrawerItem(
            context: context,
            title: 'Orders',
            icon: Icons.payment,
            routeName: OrdersScreen.routeName,
          ),
          ...buildDrawerItem(
            context: context,
            title: 'Manage Products',
            icon: Icons.edit,
            routeName: UserProductsScreen.routeName,
          )
        ],
      ),
    );
  }
}
