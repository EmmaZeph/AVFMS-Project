import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_management/features/admin/dashboard/pages/cars_page.dart';
import 'package:fuel_management/features/admin/dashboard/pages/forms/assignment/edit_assignment_page.dart';
import 'package:fuel_management/features/admin/dashboard/pages/forms/assignment/new_assignment.dart';
import 'package:fuel_management/features/admin/dashboard/pages/forms/fuel/new_fuel_purchase.dart';
import 'package:fuel_management/features/admin/dashboard/pages/forms/maintenance/edit_maintenance.dart';
import 'package:fuel_management/features/admin/dashboard/pages/maintenance_page.dart';
import 'package:fuel_management/features/admin/dashboard/pages/reports_page.dart';
import 'package:go_router/go_router.dart';
import '../features/admin/auth/views/login_page.dart';
import '../features/admin/container_page.dart';
import '../features/admin/dashboard/pages/assignments_page.dart';
import '../features/admin/dashboard/pages/dashboard_home.dart';
import '../features/admin/dashboard/pages/drivers_page.dart';
import '../features/admin/dashboard/pages/forms/car/edit_car_from.dart';
import '../features/admin/dashboard/pages/forms/car/new_car_form.dart';
import '../features/admin/dashboard/pages/forms/driver/edit_driver_form.dart';
import '../features/admin/dashboard/pages/forms/driver/new_driver_forms.dart';
import '../features/admin/dashboard/pages/forms/fuel/edit_fuel_purchase.dart';
import '../features/admin/dashboard/pages/forms/maintenance/new_maintenance.dart';
import '../features/admin/dashboard/pages/fuel_purchace_page.dart';
import '../features/admin/dashboard/views/dashboard_main.dart';
import 'router_items.dart';

class MyRouter {
  MyRouter({
    required this.ref,
    required this.context,
  });

  final BuildContext context;
  final WidgetRef ref;

  router() => GoRouter(
          initialLocation: RouterItem.loginRoute.path,
          redirect: (context, state) {
            var route = state.fullPath;
            //check if widget is done building
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (route != null && route.isNotEmpty) {
                var item = RouterItem.getRouteByPath(route);
                ref.read(routerProvider.notifier).state = item.name;
              }
            });
            return null;
          },
          routes: [
            ShellRoute(
                builder: (context, state, child) {
                  return ContainerPage(
                    child: child,
                  );
                },
                routes: [
                  GoRoute(
                      path: RouterItem.loginRoute.path,
                      builder: (context, state) {
                        return const LoginPage();
                      }),
                ]),
            ShellRoute(
                builder: (context, state, child) {
                  return DashBoardMainPage(
                    child,
                  );
                },
                routes: [
                  GoRoute(
                      path: RouterItem.dashboardRoute.path,
                      builder: (context, state) {
                        return const DashboardHomePage();
                      }),
                  GoRoute(
                      path: RouterItem.carsRoute.path,
                      builder: (context, state) {
                        return const CarsPage();
                      }),
                  GoRoute(
                      path: RouterItem.driversRoute.path,
                      builder: (context, state) {
                        return const DriversPage();
                      }),
                  GoRoute(
                      path: RouterItem.assignmentRoute.path,
                      builder: (context, state) {
                        return const AssignmentsPage();
                      }),
                  GoRoute(
                      path: RouterItem.fuelPurchaseRoute.path,
                      name: RouterItem.fuelPurchaseRoute.name,
                      builder: (context, state) {
                        return const FuelPurchasePage();
                      }),

                  //forms page
                  GoRoute(
                    path: RouterItem.newCarRoute.path,
                    name: RouterItem.newCarRoute.name,
                    builder: (context, state) {
                      return const NewCarForm();
                    },
                  ),
                  GoRoute(path: RouterItem.editCarRoute.path,
                  name: RouterItem.editCarRoute.name,
                   builder: (context, state) {
                    var id = state.pathParameters['id'];
                    return  EditCarFrom(id: id!,);
                  }),

                  GoRoute(path: RouterItem.newDriverRoute.path,
                  name: RouterItem.newDriverRoute.name,
                   builder: (context, state) {
                    return  const NewDriverForm();
                  }),

                  GoRoute(path: RouterItem.editDriverRoute.path,
                  name: RouterItem.editDriverRoute.name,
                   builder: (context, state) {
                    var id = state.pathParameters['id'];
                    return  EditDriverForm(id: id!);
                  }),

                  GoRoute(path: RouterItem.newAssignmentRoute.path,
                  name: RouterItem.newAssignmentRoute.name,
                   builder: (context, state) {
                    return  const NewAssignment();
                  }),

                  GoRoute(path: RouterItem.editAssignmentRoute.path,
                  name: RouterItem.editAssignmentRoute.name,
                   builder: (context, state) {
                    var id = state.pathParameters['id'];
                    return  EditAssignmentPage(id: id!);
                  }),

                  GoRoute(path: RouterItem.newFuelPurchaseRoute.path,
                  name: RouterItem.newFuelPurchaseRoute.name,
                   builder: (context, state) {
                    return  const NewFuelPurchase();
                  }),

                  GoRoute(path: RouterItem.editFuelPurchaseRoute.path,
                  name: RouterItem.editFuelPurchaseRoute.name,
                   builder: (context, state) {
                    var id = state.pathParameters['id'];
                    return  EditFuelPurchase(id: id!);
                  }),

                  GoRoute(path: RouterItem.maintenanceRoute.path,
                  name: RouterItem.maintenanceRoute.name,
                   builder: (context, state) {
                    return  const MaintenancePage();
                  }),
                  GoRoute(path: RouterItem.newMaintenanceRoute.path,
                  name: RouterItem.newMaintenanceRoute.name,
                   builder: (context, state) {
                    return  const NewMaintenance();
                  }),
                  GoRoute(path: RouterItem.editMaintenanceRoute.path,
                  name:  RouterItem.editMaintenanceRoute.name,
                  builder: (context, state) {
                    var id = state.pathParameters['id'];
                    return  EditMaintenance(id: id!,);
                  },
                  ),

                  GoRoute(path: RouterItem.reportRoute.path,
                  name: RouterItem.reportRoute.name,
                   builder: (context, state) {
                    return  const ReportsPage();
                  }),
                  
                
                ])
          ]);

  void navigateToRoute(RouterItem item) {
    ref.read(routerProvider.notifier).state = item.name;
    context.go(item.path);
  }

  void navigateToNamed(
      {required Map<String, String> pathPrams,
      required RouterItem item,
      Map<String, dynamic>? extra}) {
    ref.read(routerProvider.notifier).state = item.name;
    context.goNamed(item.name, pathParameters: pathPrams, extra: extra);
  }
}

final routerProvider = StateProvider<String>((ref) {
  return RouterItem.loginRoute.name;
});
