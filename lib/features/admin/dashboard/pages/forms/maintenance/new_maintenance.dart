import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fuel_management/core/views/custom_dialog.dart';
import 'package:fuel_management/core/views/custom_drop_down.dart';
import 'package:fuel_management/core/views/custom_input.dart';
import 'package:fuel_management/features/admin/dashboard/pages/forms/provider/new_edit_maintenance_provider.dart';
import 'package:fuel_management/router/router.dart';
import 'package:fuel_management/router/router_items.dart';
import 'package:fuel_management/utils/colors.dart';
import 'package:image_network/image_network.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/functions/int_to_date.dart';
import '../../../../../../core/views/custom_button.dart';
import '../../../../../../utils/styles.dart';
import '../../../data/car_model.dart';
import '../../../data/driver_model.dart';
import '../../../provider/cars_provider.dart';
import '../../../provider/drivers_provider.dart';
import '../provider/fuel_purchase_provider.dart';

class NewMaintenance extends ConsumerStatefulWidget {
  const NewMaintenance({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewMaintenanceState();
}

class _NewMaintenanceState extends ConsumerState<NewMaintenance> {
  final formKey = GlobalKey<FormState>();

  final receiptController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var notifier = ref.read(newMaintenanceProvider.notifier);
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
                        'New Maintenance Records'.toUpperCase(),
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
                              text: ref.watch(newMaintenanceProvider).date != 0
                                  ? intToDate(
                                      ref.watch(newMaintenanceProvider).date)
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
                                  ref.watch(newMaintenanceProvider).driverName;
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
                                  ref.watch(newMaintenanceProvider).carId;
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
                    text: 'Save Records',
                    radius: 10,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        if (ref
                            .watch(newMaintenanceProvider)
                            .driverId
                            .isEmpty) {
                          CustomDialogs.toast(
                              message: 'Please select driver',
                              type: DialogType.error);
                          return;
                        }
                        if (ref.watch(receiptImageProvider) == null) {
                          CustomDialogs.toast(
                              message: 'Please upload receipt image',
                              type: DialogType.error);
                          return;
                        }
                        if (ref.watch(newMaintenanceProvider).carId.isEmpty) {
                          CustomDialogs.toast(
                              message: 'Please select Car',
                              type: DialogType.error);
                          return;
                        }
                        notifier.saveRecords(ref: ref, form: formKey);
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
