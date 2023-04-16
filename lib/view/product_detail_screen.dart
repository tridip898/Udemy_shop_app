import 'package:flutter/material.dart';
import 'package:shop_app/provider/product.dart';
import '../provider/product_provider.dart';
import 'package:provider/provider.dart';


class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final productId=ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<ProductProvider>(context,listen: false).findById(productId);
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text(loadedProduct.title),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(loadedProduct.imageUrl,fit: BoxFit.fill,),
                ),
                SizedBox(height: 10,),
                Text("\$${loadedProduct.price}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  child: Text(loadedProduct.description,softWrap: true,textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
                )
              ],
            ),
          ),
    ));
  }
}
