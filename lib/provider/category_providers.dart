import 'dart:ui';

import 'package:expense/models/category_model.dart';
import 'package:expense/repositories/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentPage = StateProvider<int>((ref) => 0);
final searchValue = StateProvider<String>((ref) => "");
final categoryRepositoryProvider = StateProvider((ref) {
  return CategoryRepository();
});

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.getCategories();
});

final selectedIconCategory = StateProvider<String>((ref) => "home");

final listOfColorsProvider = StateProvider<Map<String, Color>>(
  (ref) => {
    "home": Colors.purpleAccent,
    "transport": Colors.red,
    "food": Colors.orange,
    "groceries": Colors.purple,
    "electric": Colors.yellow,
    "travel": Colors.blueAccent,
    "internet": Colors.deepPurpleAccent,
    "water": Colors.blue,
  },
);

final iconListProvider = StateProvider<Map<String, IconData>>(
  (ref) => {
    "home": Icons.home,
    "transport": Icons.directions_car,
    "food": Icons.fastfood,
    "groceries": FontAwesomeIcons.basketShopping,
    "electric": Icons.electric_bolt,
    "travel": Icons.flight,
    "internet": Icons.wifi,
    "water": FontAwesomeIcons.droplet,
  },
);
