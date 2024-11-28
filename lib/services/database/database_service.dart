import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  static Future<QuerySnapshot> searchUser(String searchPhrase) {
    return _firebaseFirestore.collection("User").where("email", arrayContains: searchPhrase).get();
  }
  
}