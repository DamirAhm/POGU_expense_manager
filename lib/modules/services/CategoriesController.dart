import 'package:flutter/cupertino.dart';
import 'package:test_app/modules/models/Category.dart';

class CategoriesController extends ChangeNotifier {
  final _categories = <Category>[];

  CategoriesController({List<Category>? categories}) {
    if (categories != null) {
      _categories.addAll(categories);
    }
  }

  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  // void removeSpend(String SpendId) {
  //   _spends.removeWhere((Category) => Category.id == SpendId);
  //   notifyListeners();
  // }

  Category? findByName(String name) {
    final filteredSpends =
        _categories.where((category) => category.name == name);
    return filteredSpends.length > 0 ? filteredSpends.first : null;
  }

  List<Category> get categories => _categories;
}
