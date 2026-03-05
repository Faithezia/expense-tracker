import '../models/category_model.dart';
import '../services/database_service.dart';

class CategoryRepository {
  Future<List<CategoryModel>> getCategories() async {
    final db = await DatabaseService.database;

    final result = await db.query('categories');

    return result.map((e) => CategoryModel.fromMap(e)).toList();
  }

  Future<int?> getCategoryIdByName(String name) async {
    final db = await DatabaseService.database;

    final result = await db.query(
      'categories',
      where: 'LOWER(name) = ?',
      whereArgs: [name.toLowerCase()],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    }

    return null;
  }

  Future<int> createCategory(String name) async {
    final db = await DatabaseService.database;

    final id = await db.insert('categories', {
      'name': name,
      'icon': 'category',
    });

    return id;
  }
}
