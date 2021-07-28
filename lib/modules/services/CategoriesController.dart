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

  void removeCategory(String categoryName) {
    _categories.removeWhere((category) => category.name == categoryName);
    notifyListeners();
  }

  void toggleCategoryPicked(String categoryName) {
    final categoryToPick = findByName(categoryName);

    if (categoryToPick != null) {
      categoryToPick.togglePicked();
      notifyListeners();
    }
  }

  Category? findByName(String name) {
    final filteredSpends = _categories
        .where((category) => category.name.toLowerCase() == name.toLowerCase());
    return filteredSpends.length > 0 ? filteredSpends.first : null;
  }

  List<Category> get categories => _categories;
  List<Category> get pickedCategories =>
      _categories.where((category) => category.picked).toList();
}
