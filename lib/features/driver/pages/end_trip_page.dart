import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_management/core/views/custom_button.dart';
import 'package:fuel_management/core/views/custom_dialog.dart';
import 'package:fuel_management/core/views/custom_input.dart';
import 'package:fuel_management/features/admin/dashboard/data/assignment_model.dart';
import 'package:fuel_management/features/admin/dashboard/services/car_services.dart';

import '../../../utils/styles.dart';
import '../../admin/dashboard/services/assignment_services.dart';

class EndTripPage extends ConsumerStatefulWidget {
  const EndTripPage({super.key, required this.assignment});
  final AssignmentModel assignment;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EndTripPageState();
}

class _EndTripPageState extends ConsumerState<EndTripPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var style = Styles(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: style.width,
                  padding: const EdgeInsets.all(12.0),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.arrow_back)),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'End Trip',
                                  style: style.body(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFields(
                        label: 'Fuel Level (litres)',
                        hintText: 'Enter fuel level',
                        keyboardType: TextInputType.number,
                        validator: (level){
                          if (level==null|| level.isEmpty) {
                            return 'Fuel level is required';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          ref
                              .read(selectedAssignmentProvider.notifier)
                              .setFuelLevel(double.parse(value!));
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                        text: 'End Trip',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            ref
                                .read(selectedAssignmentProvider.notifier)
                                .update(context);
                            // navigateAndReplace(context, const EndTripPage());
                          }
                        },
                        radius: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final selectedAssignmentProvider =
    StateNotifierProvider<SelectedAssignment, AssignmentModel>((ref) {
  return SelectedAssignment();
});

class SelectedAssignment extends StateNotifier<AssignmentModel> {
  SelectedAssignment() : super(AssignmentModel.empty());
  void setAssignment(AssignmentModel assignment) {
    state = assignment;
  }

  void setFuelLevel(double value) {
    state = state.copyWith(returnFuelLevel: value);
  }

  void update(BuildContext context) async {
    CustomDialogs.loading(message: 'Ending trip...');
    state = state.copyWith(
        status: 'completed',
        returnDate: DateTime.now().millisecondsSinceEpoch,
        returnTime: DateTime.now().millisecondsSinceEpoch);
    var result = await AssignmentServices.updateAssignment(state);
    if (result) {
      //update car status
      
      await CarServices.updateCarStatus(state.carId, {'status': 'available'});
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Trip ended successfully');
      //pop to previous page
      state = AssignmentModel.empty();
      Navigator.of(context).pop();
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Failed to end trip');
    }
  }
}
