import 'dart:io';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:vote_app/provider/comment.dart';
import 'package:vote_app/provider/image_provider.dart';
import 'package:vote_app/provider/loading.dart';
import 'package:vote_app/provider/userProvider.dart';
import 'package:vote_app/router/app_router.dart';
import 'package:vote_app/screen/bill_screen.dart';
import 'package:vote_app/screen/end_screen.dart';
import 'package:vote_app/screen/home_screen.dart';
import 'package:vote_app/screen/idbill_screen.dart';
import 'package:vote_app/screen/scan_code_screen.dart';

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
          ChangeNotifierProvider(create: (_) => CommentProvider()),
          ChangeNotifierProvider(create: (_) => ImagesProvider()),
          ChangeNotifierProvider(create: (_) => LoadingProvider()),
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
          onGenerateRoute: AppRouter.instance.onGenerateRoute,
        ));
  }
}
