import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_management/core/views/custom_dialog.dart';
import 'package:fuel_management/features/admin/dashboard/services/fuel_purchase_services.dart';
import '../data/fuel_model.dart';

class FuelFilter {
  List<FuelModel> items;
  List<FuelModel> filter;
  List<FuelModel> export;

  FuelFilter({
    required this.items,
    required this.filter,
    required this.export,
  });

  FuelFilter copyWith({
    List<FuelModel>? items,
    List<FuelModel>? filter,
    List<FuelModel>? export,
  }) {
    return FuelFilter(
      items: items ?? this.items,
      filter: filter ?? this.filter,
      export: export ?? this.export,
    );
  }
}

final fuelProvider = StateNotifierProvider<FuelProvider, FuelFilter>((ref) {
  return FuelProvider();
});

class FuelProvider extends StateNotifier<FuelFilter> {
  FuelProvider() : super(FuelFilter(items: [], filter: [], export: []));

  void setItems(List<FuelModel> items) {
    state = state.copyWith(items: items, filter: items);
  }

  void filterFuel(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filter: state.items);
    } else {
      final filter = state.items
          .where((element) =>
              element.carId.toLowerCase().contains(query.toLowerCase()) ||
              element.id.toLowerCase().contains(query.toLowerCase()))
          .toList();
      state = state.copyWith(filter: filter);
    }
  }

  void filterByDateRange(int start, int last) {
    if (start == 0 || last == 0) {
      state = state.copyWith(filter: state.items);
    }else{
      final filter = state.items
          .where((element){
            var date = DateTime.fromMillisecondsSinceEpoch(element.dateTime);
            return date.isAfter(DateTime.fromMillisecondsSinceEpoch(start)) && date.isBefore(DateTime.fromMillisecondsSinceEpoch(last));
          })
            
          .toList();
      state = state.copyWith(export: filter);
    }
  }

  void deletePurchase(FuelModel purchase) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Deleting purchase.....');
    var response = await FuelPurchaseServices.deleteFuelPurchase(purchase.id);
    if (response) {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Purchase deleted successfully', type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Failed to delete purchase', type: DialogType.error);
    }
  }
}
