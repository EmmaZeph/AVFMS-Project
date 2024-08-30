import 'dart:convert';

import 'package:fuel_management/features/admin/dashboard/data/fuel_model.dart';
import 'package:fuel_management/features/admin/dashboard/data/maintenance_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as web;
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:fuel_management/core/views/custom_button.dart';
import 'package:fuel_management/core/views/custom_drop_down.dart';
import '../../../../core/functions/int_to_date.dart';
import '../../../../core/views/custom_input.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/styles.dart';
import '../provider/fuel_purchace_provider.dart';
import '../provider/maintenance_provider.dart';
import 'forms/provider/reports_provider.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var notifier = ref.read(reportProvider.notifier);
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Report'.toUpperCase(),
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
          Form(
            key: formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: CustomTextFields(
                      hintText: 'Start Date',
                      label: 'Start Data',
                      controller: TextEditingController(
                          text: ref.watch(reportProvider).startDate != 0
                              ? intToDate(ref.watch(reportProvider).startDate)
                              : ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Start date is required';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          ).then((value) {
                            if (value != null) {
                              notifier
                                  .setStartDate(value.millisecondsSinceEpoch);
                              if (ref.watch(reportProvider).type ==
                                  'Fuel Purchase') {
                                ref
                                    .read(fuelProvider.notifier)
                                    .filterByDateRange(
                                        ref.watch(reportProvider).startDate,
                                        ref.watch(reportProvider).lastDate);
                              } else {
                                ref
                                    .read(maintenanceProvider.notifier)
                                    .exportData(
                                        ref.watch(reportProvider).startDate,
                                        ref.watch(reportProvider).lastDate);
                              }
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: 300,
                    child: CustomTextFields(
                      hintText: 'Last Date',
                      label: 'Last Data',
                      controller: TextEditingController(
                          text: ref.watch(reportProvider).lastDate != 0
                              ? intToDate(ref.watch(reportProvider).lastDate)
                              : ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last date is required';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          ).then((value) {
                            if (value != null) {
                              notifier
                                  .setLastDate(value.millisecondsSinceEpoch);
                              if (ref.watch(reportProvider).startDate != 0) {
                                if (ref.watch(reportProvider).type ==
                                    'Fuel Purchase') {
                                  ref
                                      .read(fuelProvider.notifier)
                                      .filterByDateRange(
                                          ref.watch(reportProvider).startDate,
                                          ref.watch(reportProvider).lastDate);
                                }else{
                                  ref
                                      .read(maintenanceProvider.notifier)
                                      .exportData(
                                          ref.watch(reportProvider).startDate,
                                          ref.watch(reportProvider).lastDate);
                                }
                               
                              }
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 300,
                    child: CustomDropDown(
                        label: 'Data to Export',
                        onChanged: (value) {
                          notifier.setType(value.toString());
                          if (ref.watch(reportProvider).startDate != 0) {
                            if (value == 'Fuel Purchase') {
                              ref
                                  .read(fuelProvider.notifier)
                                  .filterByDateRange(
                                      ref.watch(reportProvider).startDate,
                                      ref.watch(reportProvider).lastDate);
                            } else {
                              ref
                                  .read(maintenanceProvider.notifier)
                                  .exportData(
                                      ref.watch(reportProvider).startDate,
                                      ref.watch(reportProvider).lastDate);
                            }
                          }
                        },
                        items: ['Fuel Purchase', 'Maintenance']
                            .map((element) => DropdownMenuItem(
                                value: element, child: Text(element)))
                            .toList()),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'pdf',
                        child: Text('Export to PDF'),
                      ),
                      const PopupMenuItem(
                        value: 'excel',
                        child: Text('Export to Excel'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'pdf') {
                        if (ref.watch(reportProvider).type == 'Fuel Purchase') {
                          exportFuelToPdf(ref.watch(fuelProvider).export.toList());
                        }else{
                          exportMaintenanceToPdf(ref.watch(maintenanceProvider).export.toList());
                        }
                      }
                    },
                    child: const CustomButton(
                      radius: 10,
                      text: 'Export Report',
                      color: secondaryColor,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          if (ref.watch(reportProvider).type == 'Fuel Purchase')
            buildFuel()
          else if (ref.watch(reportProvider).type == 'Maintenance')
            buildMaintenance()
        ],
      ),
    );
  }

  Widget buildFuel() {
    var styles = Styles(context);
    var titleStyles = styles.title(color: Colors.white, fontSize: 15);
    var rowStyles = styles.body(fontSize: 13);
    var purchases = ref.watch(fuelProvider).export.toList();
    return Expanded(
      child: DataTable2(
        columnSpacing: 30,
        horizontalMargin: 12,
        empty: Center(
            child: Text(
          'No Purchase found',
          style: rowStyles,
        )),
        minWidth: 1200,
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
            size: ColumnSize.M,
          ),
          DataColumn2(
            label: Text('Bought By'.toUpperCase()),
            size: ColumnSize.L,
          ),
          DataColumn2(
              label: Text('Quantity'.toUpperCase()),
              size: ColumnSize.S,
              fixedWidth: styles.isMobile ? null : 120),
          DataColumn2(
            label: Text('Cost'.toUpperCase()),
            size: ColumnSize.M,
          ),
          DataColumn2(
            label: Text(
              'Car No.'.toUpperCase(),
              textAlign: TextAlign.center,
            ),
            size: ColumnSize.M,
          ),
        ],
        rows: List<DataRow>.generate(purchases.length, (index) {
          var purchase = purchases[index];
          return DataRow(
            cells: [
              DataCell(Text('${index + 1}', style: rowStyles)),
              DataCell(Text(intToDate(purchase.dateTime), style: rowStyles)),
              DataCell(Text(purchase.boughtByName, style: rowStyles)),
              DataCell(Text('${purchase.quantity.toStringAsFixed(1)} litre',
                  style: rowStyles)),
              DataCell(Text('GHS ${purchase.price.toStringAsFixed(2)}',
                  style: rowStyles)),
              DataCell(Text(purchase.carId, style: rowStyles)),
            ],
          );
        }),
      ),
    );
  }

  Widget buildMaintenance() {
    var styles = Styles(context);
    var titleStyles = styles.title(color: Colors.white, fontSize: 15);
    var rowStyles = styles.body(fontSize: 13);
    var maintenance = ref.watch(maintenanceProvider).export.toList();
    return Expanded(
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
            ],
          );
        }),
      ),
    );
  }

  void exportFuelToPdf(List<FuelModel> data) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      orientation: pw.PageOrientation.landscape,
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text('Fuel Purchase'.toUpperCase(),
                style: pw.TextStyle(
                    fontSize: 20,
                    color: PdfColors.blue,
                    fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 30),
            pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FixedColumnWidth(50),
                  1: const pw.FixedColumnWidth(100),
                  2: const pw.FixedColumnWidth(100),
                  3: const pw.FixedColumnWidth(100),
                  4: const pw.FixedColumnWidth(100),
                  5: const pw.FixedColumnWidth(100),
                },
              children: [
              pw.TableRow(children: [
                pw.Text('Index',
                    style: pw.TextStyle(
                         fontWeight: pw.FontWeight.bold)),
                pw.Text('Date',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold)),
                pw.Text('Bought By',
                    style: pw.TextStyle(
                         fontWeight: pw.FontWeight.bold)),
                pw.Text('Quantity',
                    style: pw.TextStyle(
                         fontWeight: pw.FontWeight.bold)),
                pw.Text('Cost',
                    style: pw.TextStyle(
                         fontWeight: pw.FontWeight.bold)),
                pw.Text('Car No.',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold)),
              ]),
              for (var i = 0; i < data.length; i++)
                pw.TableRow(children: [
                  pw.Text('${i + 1}', ),
                  pw.Text(intToDate(data[i].dateTime),
                      ),
                  pw.Text(data[i].boughtByName,
                      ),
                  pw.Text('${data[i].quantity.toStringAsFixed(1)} litre',
                      ),
                  pw.Text('GHS ${data[i].price.toStringAsFixed(2)}',
                      ),
                  pw.Text(data[i].carId,
                      ),
                ])
            ]),
          ],
        ); // Center
      },
    ));
    var savedFile = await pdf.save();
    List<int> fileInts = List.from(savedFile);
    web.AnchorElement()
      ..href =
          "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}"
      ..setAttribute("download", "${DateTime.now().millisecondsSinceEpoch}.pdf")
      ..click();
  }

  void exportMaintenanceToPdf(List<MaintenanceModel> data){

    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      orientation: pw.PageOrientation.landscape,

      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text('Maintenance Report'.toUpperCase(),
                style: pw.TextStyle(
                    fontSize: 40,
                    color: PdfColors.blue,
                    fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 30),
            pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FixedColumnWidth(50),
                  1: const pw.FixedColumnWidth(100),
                  2: const pw.FixedColumnWidth(100),
                  3: const pw.FixedColumnWidth(100),
                  4: const pw.FixedColumnWidth(100),
                  5: const pw.FixedColumnWidth(100),
                  6: const pw.FixedColumnWidth(100),
                },
              children: [
              pw.TableRow(children: [
                pw.Text('Index',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold)),
                pw.Text('Date',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold)),
                pw.Text('Car',
                    style: pw.TextStyle(
                         fontWeight: pw.FontWeight.bold)),
                pw.Text('Done By',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold)),
                pw.Text('Maintenance Type',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold)),
                pw.Text('Description',
                    style: pw.TextStyle(
                         fontWeight: pw.FontWeight.bold)),
                pw.Text('Cost',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold)),
              ]),
              for (var i = 0; i < data.length; i++)
                pw.TableRow(children: [
                  pw.Text('${i + 1}', ),
                  pw.Text(intToDate(data[i].date),
                      ),
                  pw.Text(data[i].carNumber,
                      ),
                  pw.Text(data[i].driverName,
                      ),
                  pw.Text(data[i].maintenanceType,
                      ),
                  pw.Text(data[i].description,
                      ),
                  pw.Text('GHS ${data[i].cost.toStringAsFixed(1)}',
                      ),
                ])
            ]),
          ],
        ); // Center
      },
    ));
  }
}
