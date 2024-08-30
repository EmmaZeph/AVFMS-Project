import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fuel_management/features/admin/dashboard/data/maintenance_model.dart';

class MaintenanceServices {

  static final CollectionReference _maintenanceCollection = FirebaseFirestore.instance.collection('maintenance');

static String getMaintenanceId() {
    return _maintenanceCollection.doc().id;
  }
  static Future<bool> addMaintenance(MaintenanceModel maintenance) async {
    try {
      await _maintenanceCollection.doc(maintenance.id).set(maintenance.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteMaintenance(String id) async {
    try {
      await _maintenanceCollection.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateMaintenance(MaintenanceModel maintenance) async {
    try {
      await _maintenanceCollection.doc(maintenance.id).update(maintenance.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Stream<List<MaintenanceModel>> getMaintenances() {
    return _maintenanceCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => MaintenanceModel.fromMap(doc.data() as Map<String,dynamic>)).toList();
    });
  }

  static Future<String>uploadImage(Uint8List uint8list) async{
     try {
      var ref = FirebaseStorage.instance
          .ref()
          .child('receipts/${DateTime.now().millisecondsSinceEpoch}');
      var uploadTask =
          ref.putData(uint8list, SettableMetadata(contentType: 'image/jpeg'));
      var url = await (await uploadTask).ref.getDownloadURL();
      return url;
    } catch (e) {
      return '';
    }
  }
}