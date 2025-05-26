import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/logger.dart';
import 'firebase_core.dart';

class MyFireStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = "update_app";
  final String _softDocId = "soft";
  final String _forceDocId = "force";
  bool initialized = false;

  Future<List<String>> getIds(String docId) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection(_collectionName).doc(docId).get();

      if (doc.exists) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null && data["ids"] is List) {
          return List<String>.from(data["ids"]);
        }
      }
    } catch (e) {
      devLog("Error fetching ids: $e");
    }
    return [];
  }

  Future<void> init() async {
    if (initialized) return;
    await firebaseCore.init();
    initialized = true;
  }

  Future<void> addData(
      String collection, String path, Map<String, dynamic> data) async {
    await init();
    await _firestore.collection(collection).doc(path).set(data);
  }

  Future<void> addDataAutoId(
      String collection, Map<String, dynamic> data) async {
    await init();
    await _firestore.collection(collection).add(data);
  }
}

final firestore = MyFireStore();
