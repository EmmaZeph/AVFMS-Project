import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_management/core/functions/int_to_date.dart';
import 'package:fuel_management/core/views/custom_input.dart';
import 'package:fuel_management/features/admin/dashboard/provider/maintenance_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/views/custom_button.dart';
import '../../../../core/views/custom_dialog.dart';
import '../../../../router/router.dart';
import '../../../../router/router_items.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/styles.dart';
import 'forms/provider/new_edit_maintenance_provider.dart';

class MaintenancePage extends ConsumerStatefulWidget {
  const MaintenancePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MaintenancePageState();
}

class _MaintenancePageState extends ConsumerState<MaintenancePage> {
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var titleStyles = styles.title(color: Colors.white, fontSize: 15);
    var rowStyles = styles.body(fontSize: 13);
    var maintenance = ref.watch(maintenanceProvider).filter;
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Maintenance History'.toUpperCase(),
            style: styles.title(fontSize: 35, color: primaryColor),
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            color: secondaryColor,
            thickness: 2,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: styles.width * .4,
                child: CustomTextFields(
                  hintText: 'Search a car',
                  onChanged: (query) {
                    ref.read(maintenanceProvider.notifier).filter(query);
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              CustomButton(
                text: 'Add New Records',
                radius: 10,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                onPressed: () {
                  context.go(RouterItem.newMaintenanceRoute.path);
                },
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: DataTable2(
              columnSpacing: 30,
              horizontalMargin: 12,
              isHorizontalScrollBarVisible: true,
              empty: Center(
                  child: Text(
                'No Maintenance History ',
                style: rowStyles,
              )),
              minWidth: styles.width * .9,
              headingRowColor: WidgetStateColor.resolveWith(
                  (states) => primaryColor.withOpacity(0.6)),
              headingTextStyle: titleStyles,
              columns: [
                DataColumn2(
                    label: Text(
                      'INDEX',
                      style: titleStyles,
                    ),
                    fixedWidth: styles.largerThanMobile ? 80 : null),
                DataColumn2(
                  label: Text('Date'.toUpperCase()),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                    label: Text('Car'.toUpperCase()),
                    size: ColumnSize.S,
                    fixedWidth: styles.isMobile ? null : 120),
                DataColumn2(
                  label: Text('Done By'.toUpperCase()),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                  label: Text('Maintenance Type'.toString()),
                  size: ColumnSize.M,
                ),
                DataColumn2(
                  label: Text(
                    'Description'.toUpperCase(),
                    textAlign: TextAlign.center,
                  ),
                  size: ColumnSize.L,
                ),
                DataColumn2(
                  label: Text('Cost'.toString()),
                  size: ColumnSize.S,
                  fixedWidth: styles.isMobile ? null : 150,
                ),
                DataColumn2(
                  label: Text('Action'.toUpperCase()),
                  size: ColumnSize.S,
                  fixedWidth: styles.isMobile ? null : 150,
                ),
              ],
              rows: List<DataRow>.generate(maintenance.length, (index) {
                var data = maintenance[index];
                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}', style: rowStyles)),
                    DataCell(Text(
                        intToDate(
                          data.date,
                        ),
                        style: rowStyles)),
                    DataCell(Text(data.carNumber, style: rowStyles)),
                    DataCell(Text(data.driverName, style: rowStyles)),
                    DataCell(Text(data.maintenanceType, style: rowStyles)),
                    DataCell(Text(data.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: rowStyles)),
                    DataCell(Text('GHS ${data.cost.toStringAsFixed(1)}',
                        style: rowStyles)),
                    DataCell(
                      Row(
                        children: [
                          //delete and edit
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              ref
                                  .read(editMaintenanceProvider.notifier)
                                  .setMaintenance(data);
                              if (ref
                                  .watch(editMaintenanceProvider)
                                  .id
                                  .isNotEmpty) {
                                MyRouter(context: context, ref: ref)
                                    .navigateToNamed(
                                        pathPrams: {'id': data.id},
                                        item: RouterItem.editMaintenanceRoute);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              CustomDialogs.showDialog(
                                message:
                                    'Are you sure you want to delete this records?',
                                type: DialogType.warning,
                                secondBtnText: 'Delete',
                                onConfirm: () {
                                  ref
                                      .read(maintenanceProvider.notifier)
                                      .deleteRecord(data);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
