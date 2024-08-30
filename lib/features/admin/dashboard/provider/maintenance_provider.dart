import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_management/core/views/custom_dialog.dart';
import 'package:fuel_management/features/admin/dashboard/data/maintenance_model.dart';
import 'package:fuel_management/features/admin/dashboard/services/maintenance_services.dart';

class MaintenanceFilter {
  List<MaintenanceModel> items;
  List<MaintenanceModel> filter;
  List<MaintenanceModel> export;
  MaintenanceFilter({
    required this.items,
    required this.filter,
    required this.export,
  });

  MaintenanceFilter copyWith({
    List<MaintenanceModel>? items,
    List<MaintenanceModel>? filter,
    List<MaintenanceModel>? export,
  }) {
    return MaintenanceFilter(
      items: items ?? this.items,
      filter: filter ?? this.filter,
      export: export ?? this.export,
    );
  }
}

final maintenanceProvider =
    StateNotifierProvider<MaintenanceProvider, MaintenanceFilter>((ref) {
  return MaintenanceProvider();
});

class MaintenanceProvider extends StateNotifier<MaintenanceFilter> {
  MaintenanceProvider() : super(MaintenanceFilter(items: [], filter: [], export: []));

  void setItems(List<MaintenanceModel> maintenance) {
    state = state.copyWith(items: maintenance, filter: maintenance);
  }

  void filter(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filter: state.items);
    } else {
      state = state.copyWith(
        filter: state.items
            .where((element) =>
                element.carNumber.toLowerCase().contains(query.toLowerCase()) ||
                element.driverName.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  void filterByDateRange(DateTime start, DateTime end) {
    state = state.copyWith(
      filter: state.items.where((element) {
        var date = DateTime.fromMillisecondsSinceEpoch(element.date);
        return date.isAfter(start) && date.isBefore(end);
      }).toList(),
    );
  }

  void exportData(int start, int last) {
    if (start == 0 || last == 0) {
      state = state.copyWith(filter: state.items);
    } else {
      final filter = state.items
          .where((element) 
          {
            var date = DateTime.fromMillisecondsSinceEpoch(element.date);
            return date.isAfter(DateTime.fromMillisecondsSinceEpoch(start)) && date.isBefore(DateTime.fromMillisecondsSinceEpoch(last));

          })
             
          .toList();
      state = state.copyWith(export: filter);
    }
  }

  void deleteRecord(MaintenanceModel data) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: "Deleting Maintenance ....");

    var results = await MaintenanceServices.deleteMaintenance(data.id);
    CustomDialogs.dismiss();
    if (results) {
      CustomDialogs.showDialog(
          message: 'Data deleted successfully', type: DialogType.success);
    }else{
      CustomDialogs.showDialog(
          message: 'Failed to deleted records', type: DialogType.error);
    }
  }
}
