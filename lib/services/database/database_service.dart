import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final _result = {};
  get result => _result;

  searchUser(String searchPhrase) async {
    // clear the previous result
    _result.clear();

    var result = await _firebaseFirestore
        .collection("User")        
        .where("email", isEqualTo: searchPhrase)
        .get();
    
    for (var element in result.docs) {
        _result[_result.length] = element;
        log("data: $element");
      }
    notifyListeners();
  }
}
