import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();


  Future<dynamic> navigateTo(var route) {
    return navigatorKey.currentState.push(route);
  }

  void setupLocator() {
    locator.registerLazySingleton(() => NavigationService());
  }
}