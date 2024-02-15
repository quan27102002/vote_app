import 'package:flutter/material.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/router/app_router.dart';
import 'package:vote_app/screen/home_screen.dart';
import 'package:vote_app/widget/emotion/comment.dart';

void main() {
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
      home: EmotionScreen(),
    );
  }
}
