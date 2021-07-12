import 'package:flutter/material.dart';

class Category {
  Category({required String name, required IconData icon})
      : this._name = name,
        this._icon = icon;

  final String _name;
  final IconData _icon;
  bool picked = false;

  bool togglePicked() {
    picked = !picked;
    return picked;
  }

  String get name => this._name;
  IconData get icon => this._icon;
}
