import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/provider/userProvider.dart';
import 'package:vote_app/router/router_name.dart';
import 'package:vote_app/screen/bill_screen.dart';
import 'package:vote_app/utils/app_functions.dart';

class IdBillScreen extends StatefulWidget {
  const IdBillScreen({Key? key}) : super(key: key);

  @override
  State<IdBillScreen> createState() => _IdBillScreenState();
}

class _IdBillScreenState extends State<IdBillScreen> {
  TextEditingController idBillCustomer = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String? branchAddress = Provider.of<UserProvider>(context, listen: false).loggedInUser.branchAddress;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      title:Text(branchAddress?? "Quản lý",style: TextStyle(fontWeight:FontWeight.w600),),
        centerTitle: true,
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
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await Provider.of<UserProvider>(context, listen: false)
                    .logout();
                await prefs.remove('jwt');
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteName.login,
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: width / 3,
                    child: Image.asset(
                      "assets/images/logovietphap.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    width: width / 3,
                    child: Image.asset(
                      "assets/images/logo_uc.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
              SizedBox(
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
                            backgroundColor: Color.fromRGBO(47, 179, 178, 1)),
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Thông báo'),
                                  content: Text('Vui lòng điền mã hoá đơn.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          AppFunctions.hideKeyboard(context);
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
            ],
          ),
        ),
      ),
    );
  }
}
