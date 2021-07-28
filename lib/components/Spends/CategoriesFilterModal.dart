import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/modules/services/CategoriesController.dart';

class CategoriesFilterModal extends StatefulWidget {
  CategoriesFilterModal({Key? key}) : super(key: key);
  @override
  _CategoriesFilterModalState createState() => _CategoriesFilterModalState();
}

class _CategoriesFilterModalState extends State<CategoriesFilterModal> {
  ButtonStyle _getButtonStyle(bool picked) {
    if (picked) {
      return ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).primaryColor));
    } else {
      return ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).accentColor));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesController>(
        builder: (context, categoriesController, child) => Container(
              child: GridView.count(
                  padding: EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: categoriesController.categories
                      .map((category) => Container(
                          child: ElevatedButton(
                              onPressed: () => categoriesController
                                  .toggleCategoryPicked(category.name),
                              style: _getButtonStyle(category.picked),
                              child: ListTile(
                                  minLeadingWidth: 0,
                                  leading: Icon(category.icon,
                                      size: 20,
                                      color: category.picked
                                          ? Theme.of(context).accentColor
                                          : Theme.of(context).primaryColor),
                                  title: Text(category.name,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              category.picked ? Theme.of(context).accentColor : Theme.of(context).primaryColor)))),
                          decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: 2), borderRadius: BorderRadius.all(Radius.circular(10)))))
                      .toList()),
            ));
  }
}
