import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

import '../providers/orders.dart' as ords;

class OrderItem extends StatefulWidget {
  final ords.OrderItem orders;
  const OrderItem(this.orders, {super.key});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$${widget.orders.amount}'),
          subtitle: Text(
              // DateFormat('dd/ MM/ yyyy hh : mm').format(widget.orders.dateTime),
              widget.orders.dateTime.toString()),
          trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              }),
        ),
        if (_expanded)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: min(widget.orders.products.length * 19.0 + 10, 100),
            child: ListView(
              children: widget.orders.products
                  .map((prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            prod.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${prod.quantity}x \$${prod.price}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ),
          )
      ]),
    );
  }
}
