import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async{
    final url= Uri.parse('https://flutter-shop-app-a8de1-default-rtdb.firebaseio.com/products.json');
    final timeStamp=DateTime.now();
    final response=await http.post(url,body: ({
      'amount': total,
      'dateTime': DateTime.now().toIso8601String(),
      'products': cartProducts.map((cp)=> {
        'id':cp.id,
        'title': cp.title,
        'quantity':cp.quantity,
        'price':cp.price
      }).toList()
    }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timeStamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
