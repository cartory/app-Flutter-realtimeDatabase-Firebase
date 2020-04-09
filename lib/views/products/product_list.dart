import 'package:flutter/material.dart';

import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:my_app/views/products/product_card.dart';
import 'package:my_app/providers/product_provider.dart';
import 'package:my_app/models/product_model.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  ProductProvider provider = ProductProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: _firebaseAnimatedList(),
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _firebaseAnimatedList() {
    return FirebaseAnimatedList
    (
        query: provider.reference.orderByKey(),
        itemBuilder: (_, snapshot, Animation<double> animation, int x) {
          return _productItem(Product.fromSnapshot(key: snapshot.key, value: snapshot.value));//ProductCard(Product.fromSnapshotValue(snapshot.value));
        },
        defaultChild: Center(
            child: Image.asset('assets/jar-loading.gif', width: double.infinity,))
        );
  }

  Widget _productItem(Product product){
    return Dismissible(
      key: UniqueKey(), 
      child: InkWell(
        child: ProductCard(product),
        onTap: () => Navigator.pushNamed(context, 'productForm', arguments: product),
      ),
      onDismissed: (direction){
        provider.destroy(product.id);
      },
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: () => Navigator.pushNamed(context, 'productForm',
            arguments: Product(price: 0, stock: 0)));
  }

  @override
  void initState() {
    super.initState();
    // provider.reference.onChildChanged.listen((Event e){
    //   setState(() {});
    // });
    // provider.reference.onChildRemoved.listen((Event e){
    //   setState(() {       
    //   });
    // });
  }
}