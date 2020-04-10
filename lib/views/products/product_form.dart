import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:my_app/models/product_model.dart';
import 'package:my_app/providers/product_provider.dart';

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ProductProvider provider = ProductProvider();
  Product _product;
  File image;

  @override
  Widget build(BuildContext context) {
    _product = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Product Form'),
        centerTitle: true,
        actions: _actionButtonList(),
      ),
      body: SingleChildScrollView(
          child: Container(
        child: _form(),
        padding: EdgeInsets.all(15),
      )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send), onPressed: () => _submitButtonForm()),
    );
  }

  Widget _form() {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          _imageFile(),
          _textFormField(
            'Nombre',
            initialValue: _product.name,
            textInputType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
          ),
          _textFormField(
            'Descripción',
            initialValue: _product.description,
            textCapitalization: TextCapitalization.sentences,
            textInputType: TextInputType.multiline,
          ),
          _textFormField('Precio',
              initialValue: _product.price.toString(),
              textCapitalization: TextCapitalization.none,
              textInputType:
                  TextInputType.numberWithOptions(decimal: true, signed: false),
              number: true),
          _textFormField('Cantidad',
              initialValue: _product.stock.toString(),
              textCapitalization: TextCapitalization.none,
              textInputType:
                  TextInputType.numberWithOptions(decimal: true, signed: false),
              number: true),
        ],
      ),
    );
  }

  Widget _imageFile() {
    return image == null
        ? _product.urlPhoto == null
            ? Image.asset('assets/no-image.png')
            : CachedNetworkImage(
                imageUrl: _product.urlPhoto,
                placeholder: (context, url) => CircularProgressIndicator(),
                height: 321,
                width: double.infinity,
                fit: BoxFit.scaleDown)
        : Image.file(
            image,
            fit: BoxFit.cover,
            height: 321,
          );
  }

  Widget _textFormField(String textField,
      {String initialValue,
      TextInputType textInputType,
      TextCapitalization textCapitalization,
      bool number = false}) {
    return TextFormField(
        initialValue: initialValue,
        keyboardType: textInputType,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(labelText: textField),
        onSaved: (value) => _onSavedFormField(textField, value),
        validator: (value) {
          return number
              ? _isNumber(value) ? null : 'Número Requerido'
              : value == null || value == '' && textField != 'Descripción'
                  ? 'Campo Requerido'
                  : null;
        });
  }

  List<Widget> _actionButtonList() {
    return [
      IconButton(
        icon: Icon(Icons.photo_size_select_actual),
        onPressed: () => _getImageFile(ImageSource.gallery),
      ),
      IconButton(
        icon: Icon(Icons.camera_alt),
        onPressed: () => _getImageFile(ImageSource.camera),
      ),
    ];
  }

  bool _isNumber(String s) => num.tryParse(s) != null;

  _onSavedFormField(String textField, String value) {
    switch (textField) {
      case 'Nombre':
        _product.name = value;
        break;
      case 'Descripción':
        _product.description = value;
        break;
      case 'Precio':
        _product.price = double.parse(value);
        break;
      default:
        /* stock*/
        _product.stock = double.parse(value);
    }
  }

  _submitButtonForm() {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    if (image == null && _product.id == null) return;

    _product.id == null
        ? provider.create(_product, image)
        : provider.update(_product, _product.id, image);

    Navigator.pop(context);
  }

  _getImageFile(ImageSource imageSource) async {
    image = await ImagePicker.pickImage(source: imageSource);
    setState(() {});
  }
}
