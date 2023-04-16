import 'package:flutter/material.dart';
import 'package:shop_app/widget/product_item.dart';
import '../provider/product_provider.dart';
import '../provider/product.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFav;
  const ProductGrid({Key? key, required this.showFav}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    final products = showFav? productsData.showFavorite : productsData.product;
    return GridView.builder(
        padding: EdgeInsets.all(15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: products.length,
        itemBuilder: (_, index) {
          return ChangeNotifierProvider.value(
            value: products[index],
            child: ProductItem(
                // id: products[index].id,
                // title: products[index].title,
                // imageUrl: products[index].imageUrl),
            )
          );
        });
  }
}
