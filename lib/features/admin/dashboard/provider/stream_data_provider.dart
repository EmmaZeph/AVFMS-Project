import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_management/features/admin/dashboard/data/car_model.dart';
import 'package:fuel_management/features/admin/dashboard/data/driver_model.dart';
import 'package:fuel_management/features/admin/dashboard/data/fuel_model.dart';
import 'package:fuel_management/features/admin/dashboard/provider/drivers_provider.dart';
import 'package:fuel_management/features/admin/dashboard/provider/fuel_purchace_provider.dart';
import 'package:fuel_management/features/admin/dashboard/provider/maintenance_provider.dart';
import 'package:fuel_management/features/admin/dashboard/services/car_services.dart';
import 'package:fuel_management/features/admin/dashboard/services/drivers_services.dart';
import 'package:fuel_management/features/admin/dashboard/services/fuel_purchase_services.dart';
import 'package:fuel_management/features/admin/dashboard/services/maintenance_services.dart';

import '../data/assignment_model.dart';
import '../data/maintenance_model.dart';
import '../services/assignment_services.dart';
import 'assignment_provider.dart';
import 'cars_provider.dart';

final carsStreamProvider =
    StreamProvider.autoDispose<List<CarModel>>((ref) async* {
  var stream = CarServices.getCars();
  await for (var value in stream) {
    ref.read(carsProvider.notifier).setItems(value);
    yield value;
  }
});

final driversStreamProvider =
    StreamProvider.autoDispose<List<DriverModel>>((ref) async* {
  var stream = DriversServices.getDrivers();
  await for (var value in stream) {
    ref.read(driversProvider.notifier).setItems(value);
    yield value;
  }
});

final assignmentStreamProvider =
    StreamProvider.autoDispose<List<AssignmentModel>>((ref) async* {
  var stream = AssignmentServices.getAssignments();
  await for (var value in stream) {
    ref.read(assignmentsProvider.notifier).setItems(value);
    yield value;
  }
});

final fuelStreamProvider =
    StreamProvider.autoDispose<List<FuelModel>>((ref) async* {
  var stream = FuelPurchaseServices.getFuelPurchases();
  await for (var value in stream) {
    ref.read(fuelProvider.notifier).setItems(value);
    yield value;
  }
});


final maintenanceStreamProvider =
    StreamProvider<List<MaintenanceModel>>((ref) async* {
  var data = MaintenanceServices.getMaintenances();
  await for (var maintenance in data) {
    ref.read(maintenanceProvider.notifier).setItems(maintenance);
    yield maintenance;
  }
});
