import 'package:todo_list/repositaries/Repositary.dart';

import '../models/Categorymodel.dart';

class CategoryService{

  Repositary? _repositary;

  CategoryService(){
    _repositary = Repositary();
  }

  saveCategory(Category category) async{
    return await _repositary?.insertData('helloworld', category.categoryMap());
  }

  readCategories(categoryId) async {
    return await _repositary?.readData('helloworld');
  }

  readCategoryById(categoryId) async{
    return await _repositary?.readDataById('helloworld',categoryId);
  }

  updateCategory(Category category) async{
    return await _repositary?.updateData('helloworld',category.categoryMap());
  }

  deleteCategory(categoryId) async{
    return await _repositary?.deleteData('helloworld',categoryId);
  }
}