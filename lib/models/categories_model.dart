import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Categories {
  final String? name;
  final Double? percentage;
  final Double? total;

  Categories({
    this.name,
    this.percentage,
    this.total,
  });

  factory Categories.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Categories(
      name: data?['name'],
      percentage: data?['percentage'],
      total: data?['total'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (percentage != null) "percentage": percentage,
      if (total != null) "country": total,
    };
  }
}
