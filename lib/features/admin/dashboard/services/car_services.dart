import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuel_management/features/admin/dashboard/data/car_model.dart';

class CarServices{

  static final CollectionReference<Map<String,dynamic>> cars = FirebaseFirestore.instance.collection('cars');

  static String getCarId() {
    return FirebaseFirestore.instance.collection('cars').doc().id;
  }

  static Future<bool> addCar(CarModel car) async {
    try {
      await cars.doc(car.id).set(car.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateCar(CarModel car) async {
    try {
      await cars.doc(car.id).update(car.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteCar(String id) async {
    try {
      await cars.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Stream<List<CarModel>> getCars() {
    return cars.snapshots().map((snapshot) => snapshot.docs.map((doc) => CarModel.fromMap(doc.data())).toList());
  }

  static Future<bool> updateCarStatus(String carId, Map<String, String> map) async{
    try {
      await cars.doc(carId).update(map);
      return true;
    } catch (e) {
      return false;
    }
  }
}