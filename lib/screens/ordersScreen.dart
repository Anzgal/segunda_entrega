import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../providers/app.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context);
    final app = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Órdenes"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
          itemCount: user.orders.length,
          itemBuilder: (_, index){
            OrderModel _order = user.orders[index];
            return ListTile(
              leading: Text(
                  "\$${_order.total / 100}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              title: Text(_order.description),
              subtitle: Text(DateTime.fromMillisecondsSinceEpoch(_order.createdAt).toString()),
              trailing: Text(_order.status, style: TextStyle(color: Colors.green),)

            );
          }),
    );
  }
}