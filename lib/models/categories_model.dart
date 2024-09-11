import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesModel {
  final String? id;
  final String name;
  final double percentage;
  final double total;

  CategoriesModel({
    this.id,
    required this.name,
    required this.percentage,
    required this.total,
  });

  factory CategoriesModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CategoriesModel(
      id: data?['id'],
      name: data?['name'],
      percentage: data?['percentage'],
      total: data?['total'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      "name": name,
      "percentage": percentage,
      "total": total,
    };
  }
}
