class Category {
  final String id;
  final String name;
  final String icon;

  Category({required this.id, required this.name, required this.icon});

  factory Category.fromFirestore(String id, Map<String, dynamic> data) {
    return Category(id: id, name: data['name'], icon: data['icon']);
  }
}
