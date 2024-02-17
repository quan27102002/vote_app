import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/router/app_router.dart';
import 'package:vote_app/screen/edit_comment.dart';
import 'package:vote_app/screen/home_screen.dart';
import 'package:vote_app/screen/media_screen.dart';
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
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoidmlldHBoYXBhZG1pbiIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWVpZGVudGlmaWVyIjoiMGI0NGNjZGUtNGExMC00MDg4LWE3NmMtOTliNGM3Mzk0NTVkIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiQWRtaW4iLCJleHAiOjE3MDgxNDg2MzcsImlzcyI6Imh0dHBzOi8vbG9jYWxob3N0OjgwIiwiYXVkIjpbImh0dHA6Ly9sb2NhbGhvc3Q6ODAiLCJodHRwOi8vbG9jYWxob3N0OjgwIl19.DAxKxnZcDwTaaJWeZTRX8ADADBUp3JzLNTVbU8XK0yo";
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
      // onGenerateRoute: AppRouter.instance.onGenerateRoute,
      // home: EmotionScreen(),
      home: MediaScreen(),
      // home: EditCommentScreen(),
    );
  }
}
