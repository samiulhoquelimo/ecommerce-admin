import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> productList = [];
  List<PurchaseModel> purchaseListOfSpecificProduct = [];
  List<CategoryModel> categoryList = [];

  Future<void> addCategory(String category) {
    final categoryModel = CategoryModel(
      name: category,
    );
    return DbHelper.addNewCategory(categoryModel);
  }

  Future<void> addNewProduct(
      ProductModel productModel, PurchaseModel purchaseModel) {
    final categoryModel = getCategoryModelByCatName(productModel.category);
    final count = categoryModel.productCount + purchaseModel.quantity;
    return DbHelper.addProduct(
        productModel, purchaseModel, categoryModel.id!, count);
  }

  getAllProducts() {
    DbHelper.getAllProducts().listen((event) {
      productList = List.generate(event.docs.length,
          (index) => ProductModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  getAllCategories() {
    DbHelper.getAllCategories().listen((event) {
      categoryList = List.generate(event.docs.length,
          (index) => CategoryModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  Future<String> uploadImage(String path) async {
    final imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final photoRef =
        FirebaseStorage.instance.ref().child('Pictures/$imageName');
    final uploadTask = photoRef.putFile(File(path));
    final snapshot =
        await uploadTask.whenComplete(() => null).catchError((error) {});
    return snapshot.ref.getDownloadURL();
  }

  CategoryModel getCategoryModelByCatName(String name) {
    return categoryList.firstWhere((element) => element.name == name);
  }

/*
  Future<void> rePurchase(String pid, num price, num qty, DateTime dt, String category, num stock) {
    final catModel = getCategoryModelByCatName(category);
    catModel.productCount += qty;
    final purchaseModel = PurchaseModel(
        dateModel: DateModel(
          timestamp: Timestamp.fromDate(dt),
          day: dt.day,
          month: dt.month,
          year: dt.year
        ),
        price: price,
        quantity: qty,
      productId: pid,
    );
    return DbHelper.rePurchase(purchaseModel, catModel, stock);
  }




  getAllCategories() {
    DbHelper.getAllCategories().listen((event) {
      categoryList = List.generate(event.docs.length, (index) =>
          CategoryModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }



  getPurchaseByProduct(String id) {
    DbHelper.getPurchaseByProductId(id).listen((event) {
      purchaseListOfSpecificProduct =
          List.generate(event.docs.length, (index) =>
              PurchaseModel.fromMap(event.docs[index].data()));
      print(purchaseListOfSpecificProduct.length);
      notifyListeners();
    });
  }



  Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(String id) =>
    DbHelper.getProductById(id);



  Future<void> updateProduct(String id, String field, dynamic value) {
    return DbHelper.updateProduct(id, {field : value});
  }

  */

}
