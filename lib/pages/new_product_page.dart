import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/models/product_model.dart';
import 'package:ecommerce_admin/models/purchase_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/date_model.dart';
import '../providers/product_provider.dart';
import '../utils/helper_functions.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({Key? key}) : super(key: key);
  static const String routeName = '/new_product_page';

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  String? _category;
  late ProductProvider _productProvider;

  final productNameController = TextEditingController();
  final productDescriptionController = TextEditingController();
  final productSalePriceController = TextEditingController();
  final productPurchasePriceController = TextEditingController();
  final productQuantityController = TextEditingController();

  DateTime? _productPurchaseDate;
  bool _isUploading = false;
  String? _localImagePath;
  ImageSource _imageSource = ImageSource.camera;

  final form_key = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    productSalePriceController.dispose();
    productPurchasePriceController.dispose();
    productQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _saveProduct,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
        title: const Text('Add New Product'),
      ),
      body: Form(
        key: form_key,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            TextFormField(
              controller: productNameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                prefixIcon: Icon(Icons.shopping_bag_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty!';
                }
                if (value.length > 50) {
                  return 'Name must be in 20 characters';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: productPurchasePriceController,
                    decoration: const InputDecoration(
                      labelText: 'Purchase price',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: productSalePriceController,
                    decoration: const InputDecoration(
                      labelText: 'Sale price',
                      prefixIcon: Icon(Icons.price_change),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: productQuantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      prefixIcon: Icon(Icons.production_quantity_limits),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: InputDecorator(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                    child: DropdownButtonHideUnderline(
                      child: Consumer<ProductProvider>(
                        builder: (context, provider, _) =>
                            DropdownButtonFormField<String>(
                                hint: const Text('Select'),
                                //isExpanded: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                value: _category,
                                items: provider.categoryList
                                    .map((model) => DropdownMenuItem<String>(
                                          value: model.name,
                                          child: Text(model.name!),
                                        ))
                                    .toList(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a category';
                                  }
                                  return null;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    _category = val;
                                  });
                                }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              controller: productDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Product Description',
                prefixIcon: Icon(Icons.description),
              ),
              minLines: 2,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty!';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _selectDate,
                    child: const Text('Select purchase Date'),
                  ),
                  Chip(
                    label: Text(_productPurchaseDate == null
                        ? 'No Date chosen'
                        : getFormattedDateTime(
                            _productPurchaseDate!, 'dd/MM/yyyy')),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: _localImagePath == null
                        ? const Icon(
                            Icons.photo,
                            size: 110,
                          )
                        : Image.file(
                            File(_localImagePath!),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        _imageSource = ImageSource.camera;
                        _getImage();
                      },
                      label: const Text('Camera'),
                      icon: const Icon(Icons.camera),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _imageSource = ImageSource.gallery;
                        _getImage();
                      },
                      label: const Text('Gallery'),
                      icon: const Icon(Icons.photo),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1980),
        lastDate: DateTime(2030));

    if (selectedDate != null) {
      setState(() {
        _productPurchaseDate = selectedDate;
      });
    }
  }

  void _getImage() async {
    final selectedImage =
        await ImagePicker().pickImage(source: _imageSource, imageQuality: 75);
    if (selectedImage != null) {
      setState(() {
        _localImagePath = selectedImage.path;
      });
    }
  }

  void _saveProduct() async {
    if (_productPurchaseDate == null) {
      showMsg(context, 'Please select a purchase date');
      return;
    }
    if (_localImagePath == null) {
      showMsg(context, 'Please select an image');
      return;
    }

    if (form_key.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait', dismissOnTap: false);
      final imageUrl = await _productProvider.uploadImage(_localImagePath!);
      final productModel = ProductModel(
        name: productNameController.text,
        category: _category!,
        description: productDescriptionController.text,
        salesPrice: num.parse(productSalePriceController.text),
        stock: num.parse(productQuantityController.text),
        imageUrl: imageUrl,
      );
      final purchaseModel = PurchaseModel(
        dateModel: DateModel(
          timestamp: Timestamp.fromDate(_productPurchaseDate!),
          day: _productPurchaseDate!.day,
          month: _productPurchaseDate!.month,
          year: _productPurchaseDate!.year,
        ),
        price: num.parse(productPurchasePriceController.text),
        quantity: num.parse(productQuantityController.text),
      );
      _productProvider.addNewProduct(productModel, purchaseModel).then((value) {
        EasyLoading.dismiss();
        _resetFields();
      }).catchError((error) {});
    }
  }

  void _resetFields() {
    setState(() {
      productNameController.clear();
      productDescriptionController.clear();
      productPurchasePriceController.clear();
      productSalePriceController.clear();
      productQuantityController.clear();
      _category = null;
      _productPurchaseDate = null;
      _localImagePath = null;
    });
  }
}
