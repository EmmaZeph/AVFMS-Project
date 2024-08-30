import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../router/router.dart';
import '../../../../../router/router_items.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/styles.dart';
import 'side_bar_item.dart';

class SideBar extends ConsumerWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var styles = Styles(context);
    return Container(
        width: 200,
        height: styles.height,
        color: primaryColor,
        child: Column(children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
                text: TextSpan(
                    text: 'Hello, \n',
                    style: styles.body(
                      color: Colors.white38,
                    ),
                    children: [
                  TextSpan(
                      text: 'Admin',
                      style: styles.subtitle(
                        fontWeight: FontWeight.bold,
                        fontSize: styles.isDesktop ? 20 : 16,
                        color: Colors.white,
                      ))
                ])),
          ),
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: 
                 buildAdminMenu(ref, context)
                
                    
          ),
          // footer
          Text('© 2024 All rights reserved',
              style: styles.body(color: Colors.white38, fontSize: 12)),
        ]));
  }

  Widget buildAdminMenu(WidgetRef ref, BuildContext context) {
    return Column(
      children: [
        SideBarItem(
          title: 'Dashboard',
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          icon: Icons.dashboard,
          isActive: ref.watch(routerProvider) == RouterItem.dashboardRoute.name,
          onTap: () {
            MyRouter(context: context, ref: ref)
                .navigateToRoute(RouterItem.dashboardRoute);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Cars',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.car_crash,
            isActive: ref.watch(routerProvider) == RouterItem.carsRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.carsRoute);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Maintenance',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.build,
            isActive:
                ref.watch(routerProvider) == RouterItem.maintenanceRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.maintenanceRoute);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Drivers',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.people,
            isActive:
                ref.watch(routerProvider) == RouterItem.driversRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.driversRoute);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Assignments',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.assignment,
            isActive: ref.watch(routerProvider) == RouterItem.assignmentRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.assignmentRoute);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Fuel Purchase',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.local_gas_station,
            isActive:
                ref.watch(routerProvider) == RouterItem.fuelPurchaseRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.fuelPurchaseRoute);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SideBarItem(
            title: 'Reports',
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            icon: Icons.receipt,
            isActive:
                ref.watch(routerProvider) == RouterItem.reportRoute.name,
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToRoute(RouterItem.reportRoute);
            },
          ),
        ),
        
        ],
    );
  }

}
