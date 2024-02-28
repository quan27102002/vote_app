import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/provider/userProvider.dart';
import 'package:vote_app/router/router_name.dart';
import 'package:vote_app/screen/bill_screen.dart';

class IdBillScreen extends StatefulWidget {
  const IdBillScreen({Key? key}) : super(key: key);

  @override
  State<IdBillScreen> createState() => _IdBillScreenState();
}

class _IdBillScreenState extends State<IdBillScreen> {
  TextEditingController idBillCustomer = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        centerTitle: true, // Canh giữa tiêu đề
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  'Điều khiển',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
                ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Đăng xuất'),
              onTap: () async {
                // Add your logic here for Button 4
          
                  SharedPreferences prefs = await SharedPreferences.getInstance();
             await   Provider.of<UserProvider>(context, listen: false).logout();
                 await prefs.remove('jwt'); 
               Navigator.pushNamedAndRemoveUntil(context, RouteName.login,(Route<dynamic> route) => false,);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width>1100? 290:120,
                  child: Image.asset(
                    "assets/images/logovietphap.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width:width>1100? 300:120,
                  child: Image.asset(
                    "assets/images/logo_uc.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                width: 400,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nhập mã hoá đơn',
                      ),
                      controller: idBillCustomer,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color.fromRGBO(47, 179, 178, 1) // Màu của nút
                            ),
                        onPressed: () async {
                          String id = idBillCustomer.text;
                          print(id);
                          if (id.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BillScreen(data: id),
                              ),
                            );
                          } else {
                    
                          }
                        },
                        child: Text(
                          "Xem hoá đơn",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
