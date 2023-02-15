import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class FBCollections {
  static CollectionReference users = db.collection("users");
  static CollectionReference chatRooms = db.collection("ChatRooms");
  static CollectionReference orders = db.collection("orders");
  static CollectionReference notifications = db.collection("notifications");
  static CollectionReference offers = db.collection("offers");
  static CollectionReference wallet = db.collection("wallet");
  static CollectionReference ratings = db.collection("ratings");
}
