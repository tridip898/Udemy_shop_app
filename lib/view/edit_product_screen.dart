import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var _editedProduct = ProductModel(
      id: null.toString(), title: '', description: '', imageUrl: '', price: 0.0);

  var _isInit=true;
  var _isLoading=false;
  var _initValue={
    'title':'',
    'description': '',
    'price': '',
    'imageUrl':''
  };

  @override
  void initState() {

    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies(){
    if(_isInit){
      final productId=ModalRoute.of(context)!.settings.arguments as String;
      if(productId != null){
        _editedProduct=Provider.of<ProductProvider>(context,listen: false).findById(productId);
        _initValue={
          'title':_editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          //'imageUrl': _editedProduct.imageUrl
          'imageUrl':''
        };
        _imageEditingController.text=_editedProduct.imageUrl;
      }
    }
    _isInit=false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageEditingController.dispose();
    super.dispose();
  }

  void _saveForm() async{
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading=true;
    });
    if(_editedProduct.id != null){
      await Provider.of<ProductProvider>(context,listen: false).updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading=false;
      });
      Navigator.of(context).pop();
    }else{
      try{
        await Provider.of<ProductProvider>(context, listen: false).addProduct(_editedProduct);
      }catch(error){
       await showDialog(context: context, builder: (context){
          return AlertDialog(
            title: Text("An error occured"),
            content: Text("Something went wrong!"),
            actions: [
              ElevatedButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text('Okay'))
            ],
          );
        });
       }
       //finally{
      //   setState(() {
      //     _isLoading=false;
      //   });
      //   Navigator.of(context).pop();
      // }

    }
      setState(() {
        _isLoading=false;
      });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))],
      ),
      body: _isLoading? Center(child: CircularProgressIndicator(),) : Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Input Form",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValue['title'],
                      autocorrect: true,
                      decoration: const InputDecoration(
                        labelText: "Title",
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = ProductModel(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: value.toString(),
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,

                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter title";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['price'],
                      decoration: const InputDecoration(
                        labelText: "Price",
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = ProductModel(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value!));
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter price";
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Enter a valid number greater than zero';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['description'],
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editedProduct = ProductModel(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: value.toString(),
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter description";
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 character long';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(top: 10, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: _imageEditingController.text.isEmpty
                              ? const Text("Enter a Url")
                              : FittedBox(
                                  child: Image.network(
                                    _imageEditingController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: "Image Url"),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            controller: _imageEditingController,
                            onSaved: (value) {
                              _editedProduct = ProductModel(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  imageUrl: value.toString(),
                                  price: _editedProduct.price);
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter ImageUrl";
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Enter a valid URL';
                              }
                              if (!value.endsWith('png') &&
                                  !value.endsWith('jpg') &&
                                  !value.endsWith('jpeg')) {
                                return 'Enter a valid URL';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                )),
          ))
        ],
      ),
    ));
  }
}
