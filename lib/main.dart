import 'dart:io';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/provider/userProvider.dart';
import 'package:vote_app/router/app_router.dart';
import 'package:vote_app/screen/end_screen.dart';
import 'package:vote_app/screen/home_screen.dart';
import 'package:vote_app/screen/idbill_screen.dart';
import 'package:vote_app/screen/login_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoidmlldHBoYXBhZG1pbiIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWVpZGVudGlmaWVyIjoiMGI0NGNjZGUtNGExMC00MDg4LWE3NmMtOTliNGM3Mzk0NTVkIiwicm9sZSI6IkFkbWluIiwiZXhwIjoxNzA4NTExOTMwLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo4MCIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAifQ.KgYZqx52xCS3-7NkcUAk_p6KG_0hTMcLb0n0iAaRpdQ";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('jwt', token);
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
            ),
            useMaterial3: true,
          ),
          // onGenerateRoute: AppRouter.instance.onGenerateRoute,
          home: LoginPage(),
        ));
  }
}
