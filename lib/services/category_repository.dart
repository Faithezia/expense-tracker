import '../models/category_model.dart';
import 'database_service.dart';

class CategoryRepository {
  Future<List<CategoryModel>> getCategories() async {
    final db = await DatabaseService.database;

    final result = await db.query('categories');

    return result.map((e) => CategoryModel.fromMap(e)).toList();
  }
}
