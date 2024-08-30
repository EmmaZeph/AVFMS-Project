import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_management/features/admin/auth/provider/admin_login_provider.dart';
import 'package:fuel_management/features/admin/dashboard/provider/stream_data_provider.dart';
import '../../../../core/views/custom_dialog.dart';
import '../../../../generated/assets.dart';
import '../../../../router/router.dart';
import '../../../../router/router_items.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/styles.dart';
import 'components/app_bar_item.dart';
import 'components/side_bar.dart';

class DashBoardMainPage extends ConsumerWidget {
  const DashBoardMainPage(this.child, {super.key});
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var styles = Styles(context);
    var carsStream = ref.watch(carsStreamProvider);
    var driversStream = ref.watch(driversStreamProvider);
    var assignmentStream = ref.watch(assignmentStreamProvider);
    var fuelPurchaseStream = ref.watch(fuelStreamProvider);
    var maintenanceStream = ref.watch(maintenanceStreamProvider);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            actions: [
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              //   child: CustomButton(
              //     text: 'Create Assignment',
              //     color: secondaryColor,
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              //     radius: 10,
              //     onPressed: () {
              //       //todo create assignment
              //     },
              //   ),
              // ),

              const SizedBox(width: 50),
              PopupMenuButton(
                  color: primaryColor,
                  offset: const Offset(0, 70),
                  child: CircleAvatar(
                    backgroundColor: secondaryColor,
                    backgroundImage: () {
                      return const AssetImage(Assets.imagesProfile);
                    }(),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: BarItem(
                            padding: const EdgeInsets.only(
                                right: 40, top: 10, bottom: 10, left: 10),
                            icon: Icons.logout,
                            title: 'Logout',
                            onTap: () {
                              CustomDialogs.showDialog(
                                message: 'Are you sure you want to logout?',
                                type: DialogType.info,
                                secondBtnText: 'Logout',
                                onConfirm: () {
                                  ref
                                      .read(adminLoginProvider.notifier)
                                      .logout(context: context, ref: ref);
                                  Navigator.of(context).pop();
                                },
                              );
                            }),
                      ),
                    ];
                  }),
              const SizedBox(width: 10),
            ],
            title: Row(
              children: [
                Image.asset(
                  Assets.imagesLogoWhite,
                  height: 60,
                ),
                const SizedBox(width: 10),
                if (styles.smallerThanTablet) buildAdminMenu(ref, context)
              ],
            ),
          ),
          body: Container(
            color: Colors.white60,
            padding: const EdgeInsets.all(4),
            child: styles.smallerThanTablet
                ? child
                : Row(
                    children: [
                      const SideBar(),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Container(
                              color: Colors.grey[100],
                              padding: const EdgeInsets.all(10),
                              child: carsStream.when(
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                                error: (error, stack) {
                                  return Center(child: Text(error.toString()));
                                },
                                data: (data) {
                                  return driversStream.when(
                                      data: (user) {
                                        return assignmentStream.when(
                                            data: (offices) {
                                              return fuelPurchaseStream.when(
                                                  data: (fuel) {
                                                    return maintenanceStream.when(data: (data){
                                                      return child;
                                                    }, error: (error,stack){
                                                       return Center(
                                                  child:
                                                      Text(error.toString()));
                                                    }, loading: () => const Center(
                                                      child:
                                                          CircularProgressIndicator()));

                                                  },
                                                  error: (error, stack) {
                                                    return Center(
                                                        child: Text(
                                                            error.toString()));
                                                  },
                                                  loading: () => const Center(
                                                      child:
                                                          CircularProgressIndicator()));
                                            },
                                            error: (error, stack) {
                                              return Center(
                                                  child:
                                                      Text(error.toString()));
                                            },
                                            loading: () => const Center(
                                                child:
                                                    CircularProgressIndicator()));
                                      },
                                      error: (error, stack) {
                                        return Center(
                                            child: Text(error.toString()));
                                      },
                                      loading: () => const Center(
                                          child: CircularProgressIndicator()));
                                },
                              )))
                    ],
                  ),
          )),
    );
  }

  Widget buildAdminMenu(WidgetRef ref, BuildContext context) {
    return PopupMenuButton(
      color: primaryColor,
      offset: const Offset(0, 70),
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.dashboard,
                title: 'Dashboard',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.dashboardRoute);
                  Navigator.of(context).pop();
                }),
          ),
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.car_rental,
                title: 'Cars',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.carsRoute);
                  Navigator.of(context).pop();
                }),
          ),
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.people,
                title: 'Drivers',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.driversRoute);
                  Navigator.of(context).pop();
                }),
          ),
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.assignment,
                title: 'Assignments',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.assignmentRoute);
                  Navigator.of(context).pop();
                }),
          ),
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.local_gas_station,
                title: 'Fuel Purchase',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.fuelPurchaseRoute);
                  Navigator.of(context).pop();
                }),
          ),
        ];
      },
    );
  }
}
