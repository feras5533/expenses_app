import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final String date;

  TransactionModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.date,
  });

  factory TransactionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return TransactionModel(
      id: data?['id'],
      name: data?['name'],
      category: data?['category'],
      price: data?['price'],
      date: data?['date'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
      "category": category,
      "price": price,
      "date": date,
    };
  }
}
