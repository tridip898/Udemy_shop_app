import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/widget/badge.dart';
import 'package:shop_app/widget/product_grid.dart';
import '../widget/app_drawer.dart';
enum FilterOptions { Favorite, All }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorite = false;
  var _isLoading=false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      setState(() {
        _isLoading=true;
      });
      Provider.of<ProductProvider>(context,listen: false).fetchNAdSetProducts().then((_) {
        setState(() {
          _isLoading=false;
        });
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, product, child) {
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          elevation: 0,
          title: Text(
            "ATM Chuppu",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          actions: [
            PopupMenuButton(
                icon: Icon(Icons.more_vert),
                onSelected: (FilterOptions val) {
                  setState(() {
                    if (val == FilterOptions.Favorite) {
                      _showOnlyFavorite = true;
                    } else {
                      _showOnlyFavorite = false;
                    }
                  });
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text("Only Favorite"),
                        value: FilterOptions.Favorite,
                      ),
                      PopupMenuItem(
                        child: Text("Show All"),
                        value: FilterOptions.All,
                      ),
                    ]),
            Consumer<Cart>(builder: (context, cartItems, ch) {
              return Badges(
                  child: ch as Widget,
                  value: cartItems.itemCount.toString(),
                  color: Colors.red);
            },
              child: IconButton(onPressed: (){
                Navigator.of(context).pushNamed('/cart');
              }, icon: Icon(Icons.shopping_cart)),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading? Center(child: CircularProgressIndicator(),) : ProductGrid(showFav: _showOnlyFavorite),
      ));
    });
  }
}
