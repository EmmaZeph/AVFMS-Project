import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_management/core/views/custom_dialog.dart';
import 'package:fuel_management/features/admin/dashboard/data/car_model.dart';
import 'package:fuel_management/features/admin/dashboard/data/driver_model.dart';
import 'package:fuel_management/features/admin/dashboard/pages/forms/provider/fuel_purchase_provider.dart';
import 'package:fuel_management/features/admin/dashboard/provider/cars_provider.dart';
import 'package:fuel_management/features/admin/dashboard/services/car_services.dart';
import 'package:fuel_management/features/admin/dashboard/services/maintenance_services.dart';
import 'package:fuel_management/router/router.dart';
import 'package:fuel_management/router/router_items.dart';

import '../../../data/maintenance_model.dart';

final newMaintenanceProvider =
    StateNotifierProvider<NewMaintenanceProvider, MaintenanceModel>((ref) {
  return NewMaintenanceProvider();
});

class NewMaintenanceProvider extends StateNotifier<MaintenanceModel> {
  NewMaintenanceProvider() : super(MaintenanceModel.empty());

  void setDateTime(int millisecondsSinceEpoch) {
    state = state.copyWith(date: millisecondsSinceEpoch);
  }

  void setDescription(String? value) {
    state = state.copyWith(description: value);
  }

  void setCost(String? value) {
    state = state.copyWith(cost: double.parse(value!));
  }

  void setDriver(DriverModel user) {
    state = state.copyWith(driverId: user.id, driverName: user.name);
  }

  void setCar(CarModel car) {
    state = state.copyWith(carId: car.registrationNumber, carName: car.brand);
  }

  void setMaintenanceType(value) {
    state = state.copyWith(maintenanceType: value);
  }

  void saveRecords(
      {required WidgetRef ref, required GlobalKey<FormState> form}) async {
    CustomDialogs.loading(
      message: 'Saving maintenance record',
    );
    var image = ref.watch(receiptImageProvider);
    var url = await MaintenanceServices.uploadImage(image!);
    if (url.isEmpty) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Failed to upload receipt image', type: DialogType.error);
      return;
    }
    ref.read(receiptImageProvider.notifier).state = null;
    state = state.copyWith(
      receiptPath: url,
      id: MaintenanceServices.getMaintenanceId(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    var results = await MaintenanceServices.addMaintenance(state);
    if (results) {
      //update car lastMaintenance
      var car = ref
          .watch(carsProvider)
          .items
          .where((element) => element.registrationNumber == state.carId)
          .toList()
          .firstOrNull;
      if (car != null) {
        car.lastMaintenance = state.date;
        await CarServices.updateCar(car);
      }
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Maintenance record saved successfully',
          type: DialogType.success);
      form.currentState!.reset();
      state = MaintenanceModel.empty();
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Failed to save maintenance record', type: DialogType.error);
    }
  }
}

final editMaintenanceProvider =
    StateNotifierProvider<EditMaintenanceProvider, MaintenanceModel>((ref) {
  return EditMaintenanceProvider();
});

class EditMaintenanceProvider extends StateNotifier<MaintenanceModel> {
  EditMaintenanceProvider() : super(MaintenanceModel.empty());

  void setMaintenance(MaintenanceModel maintenance) {
    state = maintenance;
  }

  void setDateTime(int millisecondsSinceEpoch) {
    state = state.copyWith(date: millisecondsSinceEpoch);
  }

  void setDescription(String? value) {
    state = state.copyWith(description: value);
  }

  void setCost(String? value) {
    state = state.copyWith(cost: double.parse(value!));
  }

  void setDriver(DriverModel user) {
    state = state.copyWith(driverId: user.id, driverName: user.name);
  }

  void setCar(CarModel car) {
    state = state.copyWith(carId: car.registrationNumber, carName: car.brand);
  }

  void setMaintenanceType(value) {
    state = state.copyWith(maintenanceType: value);
  }

  void updateRecords(
      {required WidgetRef ref, required BuildContext context}) async {
    CustomDialogs.loading(message: 'Updating records...');

    var image = ref.watch(receiptImageProvider);
    if (image != null) {
      var url = await MaintenanceServices.uploadImage(image);
      if (url.isNotEmpty) {
        ref.read(receiptImageProvider.notifier).state = null;
        state = state.copyWith(
          receiptPath: url,
        );
      }
    }
    var results = await MaintenanceServices.updateMaintenance(state);
    if (results) {
      //update car lastMaintenance
      var car = ref
          .watch(carsProvider)
          .items
          .where((element) => element.registrationNumber == state.carId)
          .toList()
          .firstOrNull;
      if (car != null) {
        car.lastMaintenance = state.date;
        await CarServices.updateCar(car);
      }
      CustomDialogs.dismiss();
      MyRouter(context: context, ref: ref)
          .navigateToRoute(RouterItem.maintenanceRoute);
      CustomDialogs.toast(
          message: 'Maintenance record updated successfully',
          type: DialogType.success);
      state = MaintenanceModel.empty();
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Failed to save maintenance record', type: DialogType.error);
    }
  }
}
