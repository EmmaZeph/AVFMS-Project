import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fuel_management/features/admin/dashboard/data/car_model.dart';
import 'package:fuel_management/features/admin/dashboard/pages/forms/provider/new_assignment_provider.dart';
import 'package:fuel_management/features/admin/dashboard/provider/assignment_provider.dart';
import 'package:fuel_management/features/admin/dashboard/provider/cars_provider.dart';
import 'package:image_network/image_network.dart';

import '../../../../../../core/functions/int_to_date.dart';
import '../../../../../../core/views/custom_button.dart';
import '../../../../../../core/views/custom_input.dart';
import '../../../../../../router/router.dart';
import '../../../../../../router/router_items.dart';
import '../../../../../../utils/colors.dart';
import '../../../../../../utils/styles.dart';
import '../../../data/driver_model.dart';
import '../../../provider/drivers_provider.dart';

class EditAssignmentPage extends ConsumerStatefulWidget {
  const EditAssignmentPage({super.key, required this.id});
  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditAssignmentPageState();
}

class _EditAssignmentPageState extends ConsumerState<EditAssignmentPage> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var notifier = ref.read(editAssignmentProvider.notifier);
    var assignment = ref.watch(assignmentsProvider).items
        .firstWhere((element) => element.id == widget.id);
  //check if widget is done building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.setAssignment(assignment);
    });
    assignment = ref.watch(editAssignmentProvider);
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
                        .navigateToRoute(RouterItem.assignmentRoute);
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
                        'Update Assignment'.toUpperCase(),
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
                        child: TypeAheadField<DriverModel>(
                          suggestionsCallback: (search) {
                            return ref
                                .watch(driversProvider)
                                .items
                                .where((element) =>
                                    element.status == 'available' &&
                                    (element.name
                                            .toLowerCase()
                                            .contains(search.toLowerCase()) ||
                                        element.id
                                            .toLowerCase()
                                            .contains(search.toLowerCase())))
                                .toList();
                          },
                          builder: (context, controller, focusNode) {
                            //wait for build to complete
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              var driver = DriverModel.fromMap(
                                  ref.watch(editAssignmentProvider).driver);
                              controller.text =
                                  driver.name.isEmpty ? '' : driver.name;
                              //remove focus
                            });
                            return CustomTextFields(
                              label: 'Select driver',
                              hintText: 'Search driver',
                              controller: controller,
                              focusNode: focusNode,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select driver';
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
                          onSelected: (driver) {
                            notifier.setDriver(driver);
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
                                    element.status == 'available' &&
                                    (element.registrationNumber
                                            .toLowerCase()
                                            .contains(search.toLowerCase()) ||
                                        element.model
                                            .toLowerCase()
                                            .contains(search.toLowerCase())))
                                .toList();
                          },
                          builder: (context, controller, focusNode) {
                            //wait for build to complete
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              controller.text =
                                  ref.watch(editAssignmentProvider).carId;
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
                      //date
                      Expanded(
                        child: CustomTextFields(
                          hintText: 'Date of Pickup',
                          label: 'Date of Pickup',
                          controller: TextEditingController(
                              text:
                                  ref.watch(editAssignmentProvider).pickupDate !=
                                          0
                                      ? intToDate(ref
                                          .watch(editAssignmentProvider)
                                          .pickupDate)
                                      : ''),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Date of Pickup Date is required';
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
                                  notifier.setInitDate(
                                      value.millisecondsSinceEpoch);
                                }
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),
                      //pickup Time
                      Expanded(
                        child: CustomTextFields(
                          hintText: 'Time of Pickup',
                          label: 'Time of Pickup',
                          controller: TextEditingController(
                              text:
                                  ref.watch(editAssignmentProvider).pickupTime !=
                                          0
                                      ? intToTime(ref
                                          .watch(editAssignmentProvider)
                                          .pickupTime)
                                      : ''),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Time of Pickup Date is required';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                if (value != null) {
                                  notifier.setInitTime(DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                    value.hour,
                                    value.minute,
                                  ).millisecondsSinceEpoch);
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      //trip route
                      Expanded(
                        child: CustomTextFields(
                          hintText: 'Trip Route',
                          initialValue: assignment.route,
                          label: 'Trip Route',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Trip Route is required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            notifier.setTripRoute(value);
                          },
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomTextFields(
                          hintText: 'Fuel Level',
                          label: 'Fuel level (Liters)',
                          keyboardType: TextInputType.number,
                          initialValue: assignment.pickupFuelLevel.toString(),
                          isDigitOnly: true,
                          max: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Fuel level is required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            notifier.setInitFuelLevel(double.parse(value!));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextFields(
                    hintText: 'Trip description',
                    label: 'Description',
                    initialValue: assignment.description,
                    maxLines: 5,
                    onSaved: (value) {
                      notifier.setDescription(value);
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomButton(
                    text: 'Update Assignment',
                    radius: 10,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        notifier.updateAssignments(
                            context: context, form: formKey);
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

}