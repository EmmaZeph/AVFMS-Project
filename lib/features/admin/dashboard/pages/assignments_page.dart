import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_management/features/admin/dashboard/data/car_model.dart';
import 'package:fuel_management/features/admin/dashboard/data/driver_model.dart';
import 'package:fuel_management/features/admin/dashboard/provider/assignment_provider.dart';
import 'package:fuel_management/utils/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/functions/int_to_date.dart';
import '../../../../core/views/custom_button.dart';
import '../../../../core/views/custom_dialog.dart';
import '../../../../core/views/custom_input.dart';
import '../../../../router/router.dart';
import '../../../../router/router_items.dart';
import '../../../../utils/colors.dart';
import 'forms/provider/new_assignment_provider.dart';

class AssignmentsPage extends ConsumerStatefulWidget {
  const AssignmentsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AssignmentsPageState();
}

class _AssignmentsPageState extends ConsumerState<AssignmentsPage> {
  final horizontalController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var titleStyles = styles.title(color: Colors.white, fontSize: 15);
    var rowStyles = styles.body(fontSize: 13);
    var assignments = ref.watch(assignmentsProvider).filter.toList();
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recorded Car Assignments'.toUpperCase(),
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
                  hintText: 'Search a purchase',
                  onChanged: (query) {
                    ref
                        .read(assignmentsProvider.notifier)
                        .filterAssignments(query);
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              CustomButton(
                text: 'Create Assignment',
                radius: 10,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                onPressed: () {
                  context.go(RouterItem.newAssignmentRoute.path);
                },
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Scrollbar(
              controller: horizontalController,
              thickness: 10,
              interactive: true,
              radius: Radius.zero,
              thumbVisibility: true,
              child: DataTable2(
                columnSpacing: 30,
                horizontalMargin: 12,
                horizontalScrollController: horizontalController,
                empty: Center(
                    child: Text(
                  'No Assignment found',
                  style: rowStyles,
                )),
                minWidth: styles.width,
                headingRowColor: WidgetStateColor.resolveWith(
                    (states) => primaryColor.withOpacity(0.6)),
                headingTextStyle: titleStyles,
                columns: [
                  DataColumn2(
                      label: Text(
                        'INDEX',
                        style: titleStyles,
                      ),
                      fixedWidth: styles.largerThanMobile ? 60 : null),
                  DataColumn2(
                    label: Text('Start Date'.toUpperCase()),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('Start Time'.toUpperCase()),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('Driver'.toUpperCase()),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('Car'.toUpperCase()),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text(
                      'Init Fuel'.toUpperCase(),
                      textAlign: TextAlign.center,
                    ),
                    size: ColumnSize.M,
                    fixedWidth: styles.isMobile ? null : 100,
                  ),
                  DataColumn2(
                    label: Text(
                      'Trip Route'.toUpperCase(),
                      textAlign: TextAlign.center,
                    ),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text(
                      'Ret. Fuel'.toUpperCase(),
                      textAlign: TextAlign.center,
                    ),
                    size: ColumnSize.M,
                    fixedWidth: styles.isMobile ? null : 100,
                  ),
                  DataColumn2(
                    label: Text('Ret. Date'.toUpperCase()),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('Ret. Time'.toUpperCase()),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text(
                      'Status'.toUpperCase(),
                      textAlign: TextAlign.center,
                    ),
                    size: ColumnSize.S,
                    fixedWidth: styles.isMobile ? null : 150,
                  ),
                  DataColumn2(
                    label: Text('Action'.toUpperCase()),
                    size: ColumnSize.S,
                    fixedWidth: styles.isMobile ? null : 100,
                  ),
                ],
                rows: List<DataRow>.generate(assignments.length, (index) {
                  var assign = assignments[index];
                  var car = CarModel.fromMap(assign.car);
                  var driver = DriverModel.fromMap(assign.driver);
                  return DataRow(
                    cells: [
                      DataCell(Text('${index + 1}', style: rowStyles)),
                      DataCell(
                          Text(intToDate(assign.pickupDate), style: rowStyles)),
                      DataCell(
                          Text(intToTime(assign.pickupTime), style: rowStyles)),
                      DataCell(Text(driver.name, style: rowStyles)),
                      DataCell(Text(car.registrationNumber, style: rowStyles)),
                      DataCell(Text(
                          '${assign.pickupFuelLevel.toStringAsFixed(1)} litre',
                          style: rowStyles)),
                      DataCell(
                          Text(assign.route, maxLines: 1, style: rowStyles)),
                      DataCell(Text(
                          assign.returnFuelLevel == 0
                              ? ''
                              : '${assign.returnFuelLevel.toStringAsFixed(1)} litre',
                          style: rowStyles)),
                      DataCell(Text(
                          assign.returnDate == 0
                              ? ''
                              : intToDate(assign.returnDate),
                          style: rowStyles)),
                      DataCell(Text(
                          assign.returnTime == 0
                              ? ''
                              : intToTime(assign.returnTime),
                          style: rowStyles)),
                      DataCell(Container(
                          width: 120,
                          // alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(
                              color: assign.status == 'completed'
                                  ? Colors.green
                                  : assign.status == 'on trip'
                                      ? Colors.blue
                                      : assign.status == 'pending'
                                          ? Colors.orange
                                          : Colors.red,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(assign.status,
                              textAlign: TextAlign.center,
                              style: rowStyles.copyWith(color: Colors.white)))),
                      DataCell(
                        Row(
                          children: [
                            if (assign.status == 'pending')
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  ref
                                      .read(editAssignmentProvider.notifier)
                                      .setAssignment(assign);
                                  if (ref
                                      .watch(editAssignmentProvider)
                                      .id
                                      .isNotEmpty) {
                                    MyRouter(context: context, ref: ref)
                                        .navigateToNamed(pathPrams: {
                                      'id': assign.id
                                    }, item: RouterItem.editAssignmentRoute);
                                  }
                                },
                              ),
                            if (assign.status == 'pending')
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  CustomDialogs.showDialog(
                                    message:
                                        'Are you sure you want to delete this assignment?',
                                    type: DialogType.warning,
                                    secondBtnText: 'Delete',
                                    onConfirm: () {
                                      ref
                                          .read(assignmentsProvider.notifier)
                                          .deleteAssignment(assign);
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
            ),
          )
        ],
      ),
    );
  }
}
