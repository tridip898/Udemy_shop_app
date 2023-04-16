import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/model/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<ProductModel> _product = [
    // ProductModel(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // ProductModel(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // ProductModel(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // ProductModel(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  //var _showFavoritesOnly=false;
  List<ProductModel> get product {
    // if(_showFavoritesOnly){
    //   return _product.where((proditem) => proditem.isFavorite).toList();
    // }
    return [..._product];
  }

  List<ProductModel> get showFavorite {
    return _product.where((prodItem) => prodItem.isFavorite).toList();
  }

  ProductModel findById(String id) {
    return _product.firstWhere((product) => product.id == id);
  }

  Future<void> fetchNAdSetProducts() async {
    var url = Uri.parse(
        'https://flutter-shop-app-a8de1-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.get(url);
      final List<ProductModel> loadedProduct = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(ProductModel(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price']));
      });
      _product=loadedProduct;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addProduct(ProductModel productModel) async {
    var url = Uri.parse(
        'https://flutter-shop-app-a8de1-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': productModel.title,
            'description': productModel.description,
            'price': productModel.price,
            'imageUrl': productModel.imageUrl,
            'isFavorite': productModel.isFavorite,

          }));
      final newProduct = ProductModel(
          id: DateTime.now().toString(),
          title: productModel.title,
          description: productModel.description,
          imageUrl: productModel.imageUrl,
          price: productModel.price);
      _product.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String productId, ProductModel newProduct) async{
    final proIndex = _product.indexWhere((proId) => proId.id == productId);
    if (proIndex >= 0) {
      final url= Uri.parse('https://flutter-shop-app-a8de1-default-rtdb.firebaseio.com/products/$productId.json');
      final response= await http.patch(url,body: json.encode({
        'title':newProduct.title,
        'description':newProduct.description,
        'price':newProduct.price,
        'imageUrl':newProduct.imageUrl
      }));
      _product[proIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async{
    final url= Uri.parse('https://flutter-shop-app-a8de1-default-rtdb.firebaseio.com/products/$id.json');
    final _existingProductIndex=_product.indexWhere((proId) => proId.id==id);
    ProductModel? _existingProduct=_product[_existingProductIndex];
    _product.removeAt(_existingProductIndex);
    notifyListeners();
    final response=await http.delete(url);
      if(response.statusCode>=400){
        _product.insert(_existingProductIndex, _existingProduct!);
        notifyListeners();
        throw HttpException('Could not delete product');
      }
      _existingProduct=null;

  }
}
