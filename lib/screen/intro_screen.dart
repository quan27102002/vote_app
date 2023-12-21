import 'package:flutter/material.dart';
import 'package:vote_app/router/router_name.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              RouteName.home, (route) => route.settings.name == RouteName.home);
        },
        child: const Text(
          'Bắt đầu đánh giá',
        ),
      ),
    );
  }
}
