import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widget/user_product.dart';
import '../provider/product_provider.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async{
    Provider.of<ProductProvider>(context).fetchNAdSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    final products = productsData.product;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Your Products",
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/edit-product');
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: ()=> _refreshProducts(context),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Expanded(
              child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (_, index) {
                    return UserProduct(
                      id: products[index].id,
                        title: products[index].title,
                        imageUrl: products[index].imageUrl);
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
