import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductModel with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  ProductModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false});

  void toggleFavorite() async{
    final oldStaus=isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url= Uri.parse('https://flutter-shop-app-a8de1-default-rtdb.firebaseio.com/products/$id.json');
    try {
    final response =  await http.patch(url,body: json.encode({
        'isFavorite':isFavorite
      }));
    if(response.statusCode>=400){
      isFavorite=oldStaus;
      notifyListeners();
    }
    }catch(error){
      isFavorite=oldStaus;
      notifyListeners();
    }
  }
}


