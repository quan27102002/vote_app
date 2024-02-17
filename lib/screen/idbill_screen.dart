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
            Container(
              width: 600,
              child: TextField(
                controller: idBillCustomer,
              ),
            ),
            ElevatedButton(
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
              child: Text("Xác nhận"),
            )
          ],
        ),
      ),
    );
  }
}
