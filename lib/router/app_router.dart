import 'package:flutter/material.dart';
import 'package:vote_app/router/router_name.dart';
import 'package:vote_app/screen/home_screen.dart';
import 'package:vote_app/screen/intro_screen.dart';
import 'package:vote_app/test/add_item.dart';

class AppRouter {
  AppRouter._instance();
  static final AppRouter instance = AppRouter._instance();
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.intro:
        return MaterialPageRoute(
            builder: (context) => const IntroScreen(),
            settings: const RouteSettings(name: RouteName.intro));
      case RouteName.home:
        return MaterialPageRoute(
            builder: (context) => const HomeScreen(),
            settings: const RouteSettings(name: RouteName.home));
      // case RouteName.item:
      //   return MaterialPageRoute(
      //       builder: (context) => const AddItem(),
      //       settings: const RouteSettings(name: RouteName.item));
    }
    return null;
  }
}
