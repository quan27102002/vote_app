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
import 'package:vote_app/screen/home_screen.dart';


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

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   Future<Map<String, dynamic>> fetchData() async {
//     final response = await http.get(Uri.parse('YOUR_API_URL'));

//     if (response.statusCode == 200) {
//       // Nếu yêu cầu thành công, chuyển đổi dữ liệu JSON
//       return json.decode(response.body);
//     } else {
//       // Nếu yêu cầu thất bại, in lỗi
//       throw Exception('Failed to load data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter API Demo'),
//       ),
//       body: FutureBuilder(
//         future: fetchData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             // Xử lý dữ liệu ở đây
//             Map<String, dynamic> data = snapshot.data!;
//             // Hiển thị dữ liệu hoặc thực hiện các thao tác khác
//             return Text('Data: $data');
//           }
//         },
//       ),
//     );
//   }
// }
