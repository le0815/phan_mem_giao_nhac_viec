import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  List test = ["adf"];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  await firebaseFirestore
      .collection("Workspace")
      .doc("YDdeNqOB7NUPkXEXDSBx")
      .update({"members": test});
}
