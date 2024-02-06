import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(child: ElevatedButton(onPressed: () async { 
        Navigator.pushNamed(context, '/'); 
        final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('role');
       await prefs.remove('userToken');
    
      },
      child: Text("Quay về màn hình đầu")),)
    );
  }
}