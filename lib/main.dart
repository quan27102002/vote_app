import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/router/app_router.dart';
import 'package:vote_app/screen/home_screen.dart';
import 'package:vote_app/widget/emotion/comment.dart';

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
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoidmlldHBoYXBhZG1pbiIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWVpZGVudGlmaWVyIjoiMGI0NGNjZGUtNGExMC00MDg4LWE3NmMtOTliNGM3Mzk0NTVkIiwicm9sZSI6IkFkbWluIiwiZXhwIjoxNzA4MDk0NzQ5LCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo4MCIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAifQ.07ChY7eJ-Ii4D99iJAdaPOsB2eFR5K1EVwBZeSsm45s";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('jwt', token);
  // HttpClient().badCertificateCallback =
  //     (X509Certificate cert, String host, int port) => true;
  // final certs = ['assets/ca/lets-encrypt-r3.pem'];
  // for (var cert in certs) {
  //   final certBytes = await PlatformAssetBundle().load(cert);
  //   SecurityContext.defaultContext
  //       .setTrustedCertificatesBytes(certBytes.buffer.asUint8List());
  // }
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      onGenerateRoute: AppRouter.instance.onGenerateRoute,
      // home: EmotionScreen(),
    );
  }
}
