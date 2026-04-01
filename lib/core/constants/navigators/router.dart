import 'package:flutter/material.dart';

import '../../../features/app.dart';
import '../../../features/dashboard/nav_bar.dart';
import 'routeName.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteName.indexPage:
      return _getPageRoute(routeName: settings.name!, viewToShow: App());
    case RouteName.homePage:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: BottomNavBar(index: 0, missionIndex: 0),
      );
    case RouteName.missionOverviewPage:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: BottomNavBar(index: 1, missionIndex: 0),
      );
    case RouteName.missionAdventuresPage:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: BottomNavBar(index: 1, missionIndex: 1),
      );
    case RouteName.missionSKillUpPage:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: BottomNavBar(index: 1, missionIndex: 2),
      );
    case RouteName.squadPage:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: BottomNavBar(index: 2, missionIndex: 0, redeemIndex: 0),
      );
    case RouteName.redeemPage:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: BottomNavBar(index: 3, missionIndex: 0, redeemIndex: 0),
      );
    case RouteName.redeemHistoryPage:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: BottomNavBar(index: 3, missionIndex: 0, redeemIndex: 1),
      );
    default:
      return MaterialPageRoute<dynamic>(
        builder: (_) => Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ),
      );
  }
}

Route<dynamic> _getPageRoute({
  required String routeName,
  required Widget viewToShow,
}) {
  return MaterialPageRoute(
    settings: RouteSettings(name: routeName),
    builder: (_) => viewToShow,
  );
}
