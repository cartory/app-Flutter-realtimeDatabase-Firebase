import 'dart:io';

import 'package:path/path.dart' as Path;

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:my_app/models/product_model.dart';

class ProductProvider {
  final _database = FirebaseDatabase.instance.reference().child('products');
  final _storage = FirebaseStorage.instance.ref();

  DatabaseReference get reference => _database;

  create(Product product, File image) async {
    product.urlPhoto = await _uploadFile(image); 
    _database.push().set(product.toJson());
  }
  
  update(Product product, String path, File image) async {
    if (image != null){
      product.urlPhoto = await _uploadFile(image);
    }
    _database.child(path).update(product.toJson());
  }
  
  destroy(String path) => _database.child(path).remove();

  Future<String> _uploadFile(File image) async {
    final storageReference =_storage.child('products/${Path.basename(image.path)}');
    await storageReference.putFile(image).onComplete;
    return await storageReference.getDownloadURL();
  }
} //  end class
