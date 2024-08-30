import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_management/core/views/custom_drop_down.dart';
import 'package:fuel_management/core/views/custom_input.dart';
import 'package:fuel_management/router/router.dart';
import 'package:fuel_management/utils/colors.dart';
import '../../../../../../core/constant.dart';
import '../../../../../../core/functions/int_to_date.dart';
import '../../../../../../core/views/custom_button.dart';
import '../../../../../../router/router_items.dart';
import '../../../../../../utils/styles.dart';
import '../provider/car_new_edit_provider.dart';

class NewCarForm extends ConsumerStatefulWidget {
  const NewCarForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewCarFormState();
}

class _NewCarFormState extends ConsumerState<NewCarForm> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var notifier = ref.read(newCarProvider.notifier);
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
                        .navigateToRoute(RouterItem.carsRoute);
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
                        'Register New Car'.toUpperCase(),
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
                          hintText: 'Car Registration Number',
                          label: 'Car Registration Number',
                          isCapitalized: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Car Registration Number is required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            notifier.setCarRegNumber(value);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: CustomDropDown(
                          label: 'Car Type',
                          items: carTypes
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          hintText: 'Car Type',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Car Model is required';
                            }
                            return null;
                          },
                          onChanged: (type) {
                            notifier.setCarType(type);
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
                        child: CustomDropDown(
                          items: carBrandsInGhana
                              .map((brans) => DropdownMenuItem(
                                  value: brans, child: Text(brans)))
                              .toList(),
                          label: 'Car Brand',
                          hintText: 'Car Brand',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Car Brand is required';
                            }
                            return null;
                          },
                          onChanged: (brand) {
                            notifier.setCarBrand(brand);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: CustomTextFields(
                          hintText: 'Car Model',
                          label: 'Car Model',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Car Model is required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            notifier.setCarModel(value);
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
                          child: CustomDropDown(
                              label: 'Fuel Type',
                              hintText: 'Fuel Type',
                              validator: (fuel) {
                                if (fuel == null || fuel.isEmpty) {
                                  return 'Fuel Type is required';
                                }
                                return null;
                              },
                              items: fuelType
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (value) {
                                notifier.setFuelType(value);
                              })),
                      const SizedBox(
                        width: 10,
                      ),
                      //fuel capacity
                      Expanded(
                        child: CustomTextFields(
                          hintText: 'Fuel Capacity',
                          label: 'Fuel Capacity (Liters)',
                          keyboardType: TextInputType.number,
                          isDigitOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Fuel Capacity is required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            notifier.setFuelCapacity(double.parse(value!));
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      //seat capacity
                      Expanded(
                        child: CustomTextFields(
                          hintText: 'Seat Capacity',
                          label: 'Seat Capacity',
                          keyboardType: TextInputType.number,
                          isDigitOnly: true,
                          validator: (capacity) {
                            if (capacity == null || capacity.isEmpty) {
                              return 'Seat Capacity is required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            notifier.setSeatCapacity(int.parse(value!));
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
                      //last maintenance date
                      Expanded(
                        child: CustomTextFields(
                          hintText: 'Last Maintenance Date',
                          label: 'Last Maintenance Date',
                          controller: TextEditingController(
                              text: ref.watch(newCarProvider).lastMaintenance !=
                                      0
                                  ? intToDate(
                                      ref.watch(newCarProvider).lastMaintenance)
                                  : ''),
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Last Maintenance Date is required';
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
                                  notifier.setLastMaintenance(
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
                          label: 'Give car description',
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
                  CustomButton(
                    text: 'Save Car',
                    radius: 10,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        notifier.saveCar(context: context, form: formKey);
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
