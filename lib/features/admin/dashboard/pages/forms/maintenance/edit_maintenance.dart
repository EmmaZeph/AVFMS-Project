import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fuel_management/features/admin/dashboard/pages/forms/provider/new_edit_maintenance_provider.dart';
import 'package:fuel_management/features/admin/dashboard/provider/maintenance_provider.dart';
import 'package:fuel_management/utils/styles.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/functions/int_to_date.dart';
import '../../../../../../core/views/custom_button.dart';
import '../../../../../../core/views/custom_dialog.dart';
import '../../../../../../core/views/custom_drop_down.dart';
import '../../../../../../core/views/custom_input.dart';
import '../../../../../../router/router.dart';
import '../../../../../../router/router_items.dart';
import '../../../../../../utils/colors.dart';
import '../../../data/car_model.dart';
import '../../../data/driver_model.dart';
import '../../../provider/cars_provider.dart';
import '../../../provider/drivers_provider.dart';
import '../provider/fuel_purchase_provider.dart';

class EditMaintenance extends ConsumerStatefulWidget {
  const EditMaintenance({super.key, required this.id});
  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditMaintenanceState();
}

class _EditMaintenanceState extends ConsumerState<EditMaintenance> {
  final formKey = GlobalKey<FormState>();

  final receiptController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var maintenance = ref
        .watch(maintenanceProvider)
        .items
        .where((element) => element.id == widget.id)
        .toList()
        .firstOrNull;
    var notifier = ref.read(editMaintenanceProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (maintenance != null) {
        notifier.setMaintenance(maintenance);
        setState(() {});
        receiptController.text = maintenance.receiptPath;
      } else {
        MyRouter(context: context, ref: ref)
            .navigateToRoute(RouterItem.maintenanceRoute);
      }
    });
    maintenance = ref.watch(editMaintenanceProvider);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(22),
      alignment: Alignment.center,
      child: SizedBox(
        width: styles.width * 0.5,
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.maintenanceRoute);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_ios),
                      Text(
                        'Back',
                        style: styles.body(fontSize: 15),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Update Maintenance Records'.toUpperCase(),
                        style: styles.title(fontSize: 35, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              color: primaryColor,
              thickness: 5,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFields(
                          hintText: 'Date of Maintenance',
                          label: 'Date of Maintenance',
                          controller: TextEditingController(
                              text: ref.watch(editMaintenanceProvider).date != 0
                                  ? intToDate(
                                      ref.watch(editMaintenanceProvider).date)
                                  : ''),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Date of maintenance is required';
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
                                lastDate: DateTime(2100),
                              ).then((value) {
                                if (value != null) {
                                  notifier.setDateTime(
                                      value.millisecondsSinceEpoch);
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: CustomTextFields(
                          hintText: 'Description',
                          label: 'Maintenance Description',
                          //isCapitalized: true,
                          initialValue: maintenance!.description,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Description is required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            notifier.setDescription(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TypeAheadField<DriverModel>(
                          suggestionsCallback: (search) {
                            return ref
                                .watch(driversProvider)
                                .items
                                .where((element) =>
                                    element.name
                                        .toLowerCase()
                                        .contains(search.toLowerCase()) ||
                                    element.id
                                        .toLowerCase()
                                        .contains(search.toLowerCase()))
                                .toList();
                          },
                          builder: (context, controller, focusNode) {
                            //wait for build to complete
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              controller.text =
                                  ref.watch(editMaintenanceProvider).driverName;
                              //remove focus
                            });
                            return CustomTextFields(
                              label: 'Select Driver',
                              hintText: 'Search Driver',
                              controller: controller,
                              focusNode: focusNode,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select Driver';
                                }
                                return null;
                              },
                              onSaved: (value) {},
                            );
                          },
                          itemBuilder: (context, user) {
                            return ListTile(
                              leading: CircleAvatar(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ClipOval(
                                    child: ImageNetwork(
                                      image: user.image,
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(10),
                              title: Text(user.name),
                              subtitle: Text(user.id),
                            );
                          },
                          onSelected: (user) {
                            notifier.setDriver(user);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TypeAheadField<CarModel>(
                          suggestionsCallback: (search) {
                            return ref
                                .watch(carsProvider)
                                .items
                                .where((element) =>
                                    element.registrationNumber
                                        .toLowerCase()
                                        .contains(search.toLowerCase()) ||
                                    element.model
                                        .toLowerCase()
                                        .contains(search.toLowerCase()))
                                .toList();
                          },
                          builder: (context, controller, focusNode) {
                            //wait for build to complete
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              controller.text =
                                  ref.watch(editMaintenanceProvider).carId;
                              //remove focus
                            });
                            return CustomTextFields(
                              label: 'Select a car',
                              hintText: 'Search a car',
                              controller: controller,
                              focusNode: focusNode,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select car';
                                }
                                return null;
                              },
                              onSaved: (value) {},
                            );
                          },
                          itemBuilder: (context, user) {
                            return ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              title: Text(user.registrationNumber),
                              subtitle: Text(user.model),
                            );
                          },
                          onSelected: (car) {
                            notifier.setCar(car);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      //maintenance type
                      Expanded(
                        child: CustomDropDown(
                            items: [
                              'Full Service',
                              'Engine',
                              'Brake',
                              'Oil',
                              'Tyre',
                              'Battery',
                              'Others'
                            ].map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            value: ref
                                .watch(editMaintenanceProvider)
                                .maintenanceType.isNotEmpty?ref
                                .watch(editMaintenanceProvider)
                                .maintenanceType:null,
                            onChanged: (value) {
                              notifier.setMaintenanceType(value);
                            },
                            validator: (type) {
                              if (type == null || type.isEmpty) {
                                return 'Maintenance type is required';
                              }
                              return null;
                            },
                            label: 'Maintenance Type'),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: CustomTextFields(
                          hintText: 'Cost',
                          label: 'Cost (GHS)',
                          keyboardType: TextInputType.number,
                          initialValue: maintenance.cost.toStringAsFixed(2),
                          isDigitOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Cost is required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            notifier.setCost(value);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      //upload receipt image
                      Expanded(
                        child: CustomTextFields(
                          hintText: 'Upload Receipt',
                          label: 'Upload Receipt',
                          isReadOnly: true,
                          controller: receiptController,
                          validator: (path) {
                            if (path == null || path.isEmpty) {
                              return 'Receipt is required';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.upload_file),
                            onPressed: () {
                              _pickImage();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomButton(
                    text: 'Update Records',
                    radius: 10,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        if (ref
                            .watch(editMaintenanceProvider)
                            .driverId
                            .isEmpty) {
                          CustomDialogs.toast(
                              message: 'Please select driver',
                              type: DialogType.error);
                          return;
                        }

                        if (ref.watch(editMaintenanceProvider).carId.isEmpty) {
                          CustomDialogs.toast(
                              message: 'Please select Car',
                              type: DialogType.error);
                          return;
                        }
                        notifier.updateRecords(ref: ref, context: context);
                      }
                    },
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ref.read(receiptImageProvider.notifier).state =
          await pickedFile.readAsBytes();
      setState(() {
        receiptController.text = pickedFile.name;
      });
    }
  }
}
