import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/Categorymodel.dart';
import '../service/CategoryService.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();
  var _editcategoryNameController = TextEditingController();
  var _editcategoryDescriptionController = TextEditingController();
  var _category = Category();
  var _categoryService = CategoryService();

  List<Category> _categoryList = <Category>[];

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  File? image;
  ImagePicker pick = ImagePicker();

  Future getCamera() async {
    var _image = await pick.pickImage(source: ImageSource.camera);

    setState(() {
      image = File(_image!.path);
    });
  }

  getAllCategories() async {
    _categoryList = <Category>[];
    var categories = await _categoryService.readCategories(context);

    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  var category;

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editcategoryNameController.text = category[0]['name'] ?? 'No Name';
      _editcategoryDescriptionController.text =
          category[0]['description'] ?? 'No Description';
    });
    _editFormDialog(context);
  }

  _clearText() {
    _categoryNameController.clear();
    _categoryDescriptionController.clear();
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              IconButton(
                  onPressed: () {
                    getCamera();
                  },
                  icon: Icon(Icons.camera)),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text("Cancel"),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.red, primary: Colors.white),
              ),
              TextButton(
                onPressed: () async {
                  // print("Category Name : ${_categoryNameController.text}");
                  // print("Category Description : ${_categoryDescriptionController.text}");
                  _category.name = _categoryNameController.text;
                  _category.description = _categoryDescriptionController.text;
                  // _category.img = _imageDisplayFunc();
                  await _categoryService.saveCategory(_category);
                  // print("result${result}");
                  getAllCategories();
                  Navigator.pop(context);
                },
                child: Text("Save"),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blue, primary: Colors.white),
              ),
            ],
            title: Text("Categories Form"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _categoryNameController,
                    decoration: InputDecoration(
                        hintText: "Write a Category",
                        label: Text("Enter Category Name")),
                  ),
                  TextField(
                    controller: _categoryDescriptionController,
                    decoration: InputDecoration(
                        hintText: "Write a Description",
                        label: Text("Enter Description")),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text("Cancel"),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.red, primary: Colors.white),
              ),
              TextButton(
                onPressed: () async {
                  // print("Category Name : ${_categoryNameController.text}");
                  // print("Category Description : ${_categoryDescriptionController.text}");
                  _category.id = category[0]['id'];
                  _category.name = _editcategoryNameController.text;
                  _category.description =
                      _editcategoryDescriptionController.text;
                  var result = await _categoryService.updateCategory(_category);
                  print("result${result}");
                  _showSuccessSnackBar("Modified");
                  Navigator.pop(context);
                  getAllCategories();
                },
                child: Text("Update"),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blue, primary: Colors.white),
              ),
            ],
            title: Text("Edit Categories Form"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 150,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    color: Colors.red,
                    child: IconButton(
                      onPressed: () {
                        getCamera();
                      },
                      icon: Icon(Icons.camera),
                    ),
                  ),
                  TextField(
                    controller: _editcategoryNameController,
                    decoration: InputDecoration(
                        hintText: "Write a Category",
                        label: Text("Enter Category Name")),
                  ),
                  TextField(
                    controller: _editcategoryDescriptionController,
                    decoration: InputDecoration(
                        hintText: "Write a Description",
                        label: Text("Enter Description")),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _deleteFormDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text("Cancel"),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.green, primary: Colors.white),
              ),
              TextButton(
                onPressed: () async {
                  var result =
                  await _categoryService.deleteCategory(categoryId);
                  print("result${result}");
                  _showSuccessSnackBar("Deleted");
                  Navigator.pop(context);
                  getAllCategories();
                },
                child: Text("Delete"),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.red, primary: Colors.white),
              ),
            ],
            title: Text("Delete Categories Form"),
          );
        });
  }

  _showSuccessSnackBar(message) {
    // var _snackbar = SnackBar(content: message);
    final snackBar = SnackBar(
      content: Text('Value Has been ${message} ...!'),
      // action: SnackBarAction(
      //   // label: 'Undo',
      //   onPressed: () {
      //     // Some code to undo the change.
      //   },
      // ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            elevation: 0.0,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                getCamera();
              },
              icon: Icon(Icons.camera))
        ],
        title: Text("Categories"),
      ),
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: ListView.builder(
            itemCount: _categoryList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                child: Card(
                  elevation: 8.0,
                  child: ListTile(
                    // leading:
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Container(
                        //   height: 50,
                        //   width: 50,
                        //   child: image == null
                        //       ? Text('Nothing to show.')
                        //       : Image.file(image!),
                        // ),
                        Text(_categoryList[index].name!),
                        Column(
                          children: [
                            IconButton(
                                onPressed: () {
                                  _deleteFormDialog(
                                      context, _categoryList[index].id);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                            IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _editCategory(
                                      context, _categoryList[index].id);
                                }),
                          ],
                        )
                      ],
                    ),
                    subtitle: Text(_categoryList[index].description!),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _clearText();
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}