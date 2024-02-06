import 'package:flutter/material.dart';
import 'package:vote_app/router/router_name.dart';
import 'package:vote_app/screen/admin_screen.dart';
import 'package:vote_app/screen/create_user_Screen.dart';
import 'package:vote_app/screen/emotion_screen.dart';
import 'package:vote_app/screen/home_screen.dart';
import 'package:vote_app/screen/intro_screen.dart';
import 'package:vote_app/screen/login_screen.dart';
import 'package:vote_app/screen/logout_screen.dart';

class AppRouter {
  AppRouter._instance();
  static final AppRouter instance = AppRouter._instance();
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.intro:
        return MaterialPageRoute(
            builder: (context) => const IntroScreen(),
            settings: const RouteSettings(name: RouteName.intro));
            case RouteName.admin:
        return MaterialPageRoute(
            builder: (context) => const Admin(),
            settings: const RouteSettings(name: RouteName.admin));
           case RouteName.create:
        return MaterialPageRoute(
            builder: (context) => const CreateUser(),
            settings: const RouteSettings(name: RouteName.create)); 
      case RouteName.home:
        return MaterialPageRoute(
            builder: (context) => const HomeScreen(),
            settings: const RouteSettings(name: RouteName.home));
              case RouteName.emotion:
        return MaterialPageRoute(
            builder: (context) =>  EmotionScreen(),
            settings: const RouteSettings(name: RouteName.emotion));
            case RouteName.logout:
        return MaterialPageRoute(
            builder: (context) =>  LogoutScreen(),
            settings: const RouteSettings(name: RouteName.logout));
             case RouteName.login:
        return MaterialPageRoute(
            builder: (context) =>  LoginPage(),
            settings: const RouteSettings(name: RouteName.login)
            );
            
    }
    return null;
  }
}
