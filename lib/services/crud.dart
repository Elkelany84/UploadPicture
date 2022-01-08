import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  Future<void> addData(blogdata) async {
    FirebaseFirestore.instance.collection('blogs').add(blogdata).catchError((e) {
      print(e);
    });
  }

  getData() async {
    return FirebaseFirestore.instance.collection('blogs').snapshots();
  }
}
