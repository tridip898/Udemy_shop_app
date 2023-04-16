import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';

import '../provider/cart.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  //
  // const ProductItem(
  //     {Key? key, required this.id, required this.title, required this.imageUrl})
  //     : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final product = Provider.of<ProductModel>(context);
    final cart = Provider.of<Cart>(context);
    return Consumer<ProductModel>(builder: (context, product, child) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed('/product-detail', arguments: product.id);
            },
            child: GridTile(
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.fill,
              ),
              footer: GridTileBar(
                backgroundColor: Colors.black26,
                leading: IconButton(
                  onPressed: () {
                    product.toggleFavorite();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Product is marked as favorite",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      backgroundColor: Colors.teal,
                      duration: Duration(seconds: 3),

                    ));
                  },
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 30,
                  ),
                  color: Colors.deepOrange,
                ),
                title: Text(
                  product.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    size: 30,
                  ),
                  onPressed: () {
                    cart.addItem(product.id, product.title, product.price);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Product is added to cart",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      backgroundColor: Colors.teal,
                      duration: Duration(seconds: 3),
                      action: SnackBarAction(
                          label: "Undo",
                          textColor: Colors.white,
                          onPressed: (){
                            cart.removeSingleItem(product.id);
                      }),
                    ));
                  },
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ));
    });
  }
}
