import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:my_app/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product _product;

  ProductCard(this._product);

  @override
  Widget build(BuildContext context) {
    final card = Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _productImage(),
            _listTile(Icons.info, _product.name, subtitle: _product.description),
            _listTile(Icons.monetization_on, _product.price.toString()),
            _listTile(Icons.store, _product.stock.toString()),
          ],
    ));

    return Container(
      child: card,
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _productImage() {
    return _product.urlPhoto == null
        ? Image(image: AssetImage('assets/no-image.png'))
        : CachedNetworkImage(
            imageUrl: _product.urlPhoto,
            placeholder: (context, url) => CircularProgressIndicator(),
            height: 315,
            width: double.infinity,
            fit: BoxFit.scaleDown);
  }

  Widget _listTile(IconData icon, String text, {String subtitle}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue, size: 26),
      title: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
    );
  }
}
