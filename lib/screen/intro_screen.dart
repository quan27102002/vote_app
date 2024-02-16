

import 'package:flutter/material.dart';
import 'package:vote_app/widget/emotion/comment.dart';
import 'package:vote_app/widget/intro/slide.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return const Slide();
  }
}
