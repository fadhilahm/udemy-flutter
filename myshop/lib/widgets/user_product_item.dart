import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  const UserProductItem(this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(title),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
