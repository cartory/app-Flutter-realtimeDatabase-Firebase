import 'package:flutter/material.dart';

import 'package:my_app/views/home_page.dart';
import 'package:my_app/views/products/product_form.dart';
import 'package:my_app/views/products/product_list.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'productList',
      routes: {
        'home': (context) => HomePage(),
        'productList': (context) => ProductList(),
        'productForm': (context) => ProductForm(),
      },
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
    );
  }

}