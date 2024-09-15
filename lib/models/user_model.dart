import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? name;
  final String? phoneNumber;

  UserModel({
    this.id,
    this.name,
    this.phoneNumber,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
      id: data?['id'],
      name: data?['name'],
      phoneNumber: data?['phoneNumber'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (name != null) "name": name,
      if (phoneNumber != null) "phoneNumber": phoneNumber,
    };
  }
}
