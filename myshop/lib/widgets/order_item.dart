import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order_item.dart' as oi;

class OrderItem extends StatefulWidget {
  final oi.OrderItem order;

  const OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(
                '${DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)}'),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
            ),
          ),
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20.0 + 10, 100),
              child: ListView.builder(
                itemCount: widget.order.products.length,
                itemBuilder: (ctx, i) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.order.products[i].title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.order.products[i].quantity}x \$${widget.order.products[i].price}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
