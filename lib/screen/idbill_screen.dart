import 'package:flutter/material.dart';
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
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                "assets/images/logo_uc.png",
              ),
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
                            // Xử lý khi id rỗng
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
