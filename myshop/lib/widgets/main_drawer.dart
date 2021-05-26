import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

import '../providers/auth.dart';

// import '../helpers/custom_route.dart';

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
        // onTap: () => Navigator.of(context).pushReplacement(
        //   CustomRoute(
        //     builder: (ctx) => OrdersScreen(),
        //   ),
        // ),
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
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..pushReplacementNamed('/');

              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
