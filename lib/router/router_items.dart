class RouterItem {
  final String path;
  final String name;
  RouterItem({
    required this.path,
    required this.name,
  });

  static final RouterItem loginRoute =
      RouterItem(path: '/login', name: 'login');
  static final RouterItem registerRoute =
      RouterItem(path: '/register', name: 'register');
  static final RouterItem forgotPasswordRoute =
      RouterItem(path: '/forgot-password', name: 'forgotPassword');

//dashboard routes

  static final RouterItem dashboardRoute =
      RouterItem(path: '/dashboard', name: 'dashboard');
  static final RouterItem carsRoute =
      RouterItem(path: '/admin/cars', name: 'card');
  static final RouterItem driversRoute =
      RouterItem(path: '/drivers', name: 'drivers');
  static final RouterItem assignmentRoute =
      RouterItem(path: '/assignment', name: 'assignment');
  static final RouterItem fuelPurchaseRoute =
      RouterItem(path: '/fuel-purchase', name: 'fuelPurchase');

      static final RouterItem maintenanceRoute =
      RouterItem(path: '/maintenance', name: 'maintenance');

      static final RouterItem reportRoute = RouterItem(path: '/report', name: 'report');

  static RouterItem newCarRoute = RouterItem(path: '/new-car', name: 'newCar');
  static RouterItem editCarRoute =
      RouterItem(path: '/edit-car/:id', name: 'editCar');

  static RouterItem newDriverRoute =
      RouterItem(path: '/new-driver', name: 'newDriver');
  static RouterItem editDriverRoute =
      RouterItem(path: '/edit-driver/:id', name: 'editDriver');

  static RouterItem newMaintenanceRoute = RouterItem(
        path: '/new-maintenance', name: 'newMaintenance');

  static RouterItem editMaintenanceRoute = RouterItem(
          path:  '/edit-maintenance/:id', name: 'editMaintenance');
  

  static RouterItem newAssignmentRoute = RouterItem(
    path: '/new-assignment',
    name: 'newAssignment',
  );
  static RouterItem editAssignmentRoute = RouterItem(
    path: '/edit-assignment/:id',
    name: 'editAssignment',
  );

  static RouterItem newFuelPurchaseRoute = RouterItem(
    path: '/new-fuel-purchase',
    name: 'newFuelPurchase',
  );
  static RouterItem editFuelPurchaseRoute = RouterItem(
    path: '/edit-fuel-purchase/:id',
    name: 'editFuelPurchase',
  );

  static List<RouterItem> allRoutes = [
    loginRoute,
    dashboardRoute,
    registerRoute,
    forgotPasswordRoute,
    carsRoute,
    driversRoute,
    assignmentRoute,
    fuelPurchaseRoute,
    maintenanceRoute,
    reportRoute,

  ];

  static RouterItem getRouteByPath(String fullPath) {
    return allRoutes.firstWhere((element) => element.path == fullPath);
  }
}
