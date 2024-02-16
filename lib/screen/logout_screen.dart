import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/provider/userProvider.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(47, 179, 178, 1),
        body: Container(
          child: ElevatedButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/');
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("jwt");
                Provider.of<UserProvider>(context, listen: false).logout();
              },
              child: Text("Quay về màn hình đầu")),
        ));
  }
}
