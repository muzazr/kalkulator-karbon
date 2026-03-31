import 'package:go_router/go_router.dart';
import 'package:project_based_learning_eco_apps/pages/air_conditioner.dart';
import 'package:project_based_learning_eco_apps/pages/electric_tool.dart';
import 'package:project_based_learning_eco_apps/pages/fuel_industry.dart';
import 'package:project_based_learning_eco_apps/pages/home.dart';
import 'package:project_based_learning_eco_apps/pages/select_feature.dart';
import 'package:project_based_learning_eco_apps/pages/vehicle.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/features',
      builder: (context, state) => const FeaturePage(),
    ),
    GoRoute(
      path: '/calculator/air-conditioner',
      builder: (context, state) => const AirConditionerCalculator(),
    ),
    GoRoute(
      path: '/calculator/fuel-industry',
      builder: (context, state) => const FuelIndustry(),
    ),
    GoRoute(
      path: '/calculator/vehicle',
      builder: (context, state) => const Vehicle(),
    ),
    GoRoute(
      path: '/calculator/electric-tool',
      builder: (context, state) => const ElectricTool(),
    ),
  ],
);
