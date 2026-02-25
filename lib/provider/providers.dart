import 'package:expense/models/category_model.dart';
import 'package:expense/services/category_repository.dart';
import 'package:flutter_riverpod/legacy.dart';
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
