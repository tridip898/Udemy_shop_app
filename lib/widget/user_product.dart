import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_provider.dart';

class UserProduct extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  const UserProduct(
      {Key? key, required this.title, required this.imageUrl, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/edit-product', arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Colors.grey,
            ),
            IconButton(
              onPressed: () {
                try{
                  Provider.of<ProductProvider>(context).deleteProduct(id); 
                }catch(error){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed Deleting")));
                }
              },
              icon: Icon(Icons.delete),
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
