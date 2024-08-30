import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_management/core/views/custom_dialog.dart';
import 'package:fuel_management/features/admin/dashboard/data/car_model.dart';
import 'package:fuel_management/features/admin/dashboard/services/car_services.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../router/router_items.dart';

final newCarProvider = StateNotifierProvider<NewCarProvider, CarModel>((ref) {
  return NewCarProvider();
});

class NewCarProvider extends StateNotifier<CarModel> {
  NewCarProvider() : super(CarModel.empty());

  void setCarRegNumber(String? value) {
    state = state.copyWith(registrationNumber: value!);
  }

  void setCarType(type) {
    state = state.copyWith(type: type);
  }

  void setCarModel(String? value) {
    state = state.copyWith(model: value!);
  }

  void setCarBrand(brand) {
    state = state.copyWith(brand: brand);
  }

  void setFuelType(value) {
    state = state.copyWith(fuelType: value);
  }

  void setFuelCapacity(double parse) {
    state = state.copyWith(fuelCapacity: parse);
  }

  void setSeatCapacity(int parse) {
    state = state.copyWith(seatCapacity: parse);
  }

  void setDescription(String? value) {
    state = state.copyWith(description: value!);
  }

  void setLastMaintenance(int millisecondsSinceEpoch) {
    state = state.copyWith(lastMaintenance: millisecondsSinceEpoch);
  }

  void saveCar(
      {required BuildContext context,
      required GlobalKey<FormState> form}) async {
    CustomDialogs.loading(message: 'Saving car .......');
    state = state.copyWith(
      status: 'available',
      id: state.registrationNumber.trim(),
    );
    var result = await CarServices.addCar(state);
    if (result) {
      //reset form
      form.currentState!.reset();
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Car saved successfully');
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Failed to save car');
    }
  }
}

final editCarProvider = StateNotifierProvider<EditCarProvider, CarModel>((ref) {
  return EditCarProvider();
});

class EditCarProvider extends StateNotifier<CarModel> {
  EditCarProvider() : super(CarModel.empty());

  void setCar(CarModel car) {
    state = car;
  }

  void setCarRegNumber(String? value) {
    state = state.copyWith(registrationNumber: value!);
  }

  void setCarType(type) {
    state = state.copyWith(type: type);
  }

  void setCarModel(String? value) {
    state = state.copyWith(model: value!);
  }

  void setCarBrand(brand) {
    state = state.copyWith(brand: brand);
  }

  void setFuelType(value) {
    state = state.copyWith(fuelType: value);
  }

  void setFuelCapacity(double parse) {
    state = state.copyWith(fuelCapacity: parse);
  }

  void setSeatCapacity(int parse) {
    state = state.copyWith(seatCapacity: parse);
  }

  void setDescription(String? value) {
    state = state.copyWith(description: value!);
  }

  void setLastMaintenance(int millisecondsSinceEpoch) {
    state = state.copyWith(lastMaintenance: millisecondsSinceEpoch);
  }

  void updateCar(
      {required BuildContext context,
      required GlobalKey<FormState> form}) async {
    CustomDialogs.loading(message: 'Updating car .......');
    var result = await CarServices.updateCar(state);
    if (result) {
      //reset form
      form.currentState!.reset();
      state = CarModel.empty();
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Car update successfully');
      context.go(RouterItem.carsRoute.path);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Failed to update car');
    }
  }
}
