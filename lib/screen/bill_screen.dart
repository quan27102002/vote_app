import 'package:flutter/material.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/model/bill_customer.dart';
import 'package:intl/intl.dart';
import 'package:vote_app/model/id_bill_customer.dart';
import 'package:vote_app/screen/home_screen.dart';

class BillScreen extends StatefulWidget {
  final String data;
  const BillScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  // BillIdUser? idBill;
  List<BillIdUser> idBill = [];
  String? userBillId;
  late BillCustomer customer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getApi(int.parse(widget.data));
    });
  }

  Future<void> getApi(int idBill) async {
    ApiResponse res = await ApiRequest.getData();
    if (res.result == true) {
      setState(() {
        List<BillCustomer> listBill = [];
        for (var e in res.data) {
          listBill.add(BillCustomer.fromJson(e));
        }
        customer = listBill.firstWhere((bill) => bill.maHoaDon == idBill);
        _isLoading = false;
      });
    } else {
      print(res.message ?? "Lỗi");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text("Họ và tên: ${customer.hoTen}"),
                Text("Mã bệnh nhân: ${customer.maBenhNhan}"),
                Text("Số điện thoại: ${customer.dienThoaiDD}"),
                Text("Mã hoá đơn: ${customer.maHoaDon}"),
                Text("Thời gian khám: ${customer.thoiGianKham ?? ''}"),
                Text("Mã chi nhánh: ${customer.maCoSo ?? ''}"),
                Text("Địa chỉ khám: ${customer.coSoKham ?? ''}"),
                Text("Bác sĩ khám: ${customer.bacSyPhuTrach ?? ''}"),
                Text("Dịch vụ:"),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Tên dịch vụ: ${customer.tenDichVu}"),
                    Text("Số lượng: ${customer.soLuong}"),
                    Text("Đơn giá: ${customer.donGia}"),
                  ],
                )
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                DateFormat currentFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
                DateTime dateTime =
                    currentFormat.parse(customer.thoiGianKham ?? '');

                DateFormat newFormat =
                    DateFormat("yyyy-MM-dd'T'HH:mm:ss.000'Z'");
                String newDateTimeString = newFormat.format(dateTime);

                final res = await ApiRequest.uploadBillCustomer(
                  customer.maHoaDon ?? 0,
                  customer.hoTen ?? "",
                  customer.maBenhNhan ?? "",
                  customer.dienThoaiDD ?? "",
                  newDateTimeString,
                  customer.maCoSo ?? "",
                  customer.coSoKham ?? "",
                  customer.bacSyPhuTrach ?? "",
                  customer.tenDichVu ?? "",
                  customer.soLuong ?? 0,
                  customer.donGia!.toInt(),
                );
                if (res.code == 200) {
                  setState(() {
                    for (var e in res.data) {
                      idBill.add(BillIdUser.fromJson(e));
                    }
                  });
                  userBillId = idBill[0].id;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EmotionScreen(userBillId: userBillId ?? ""),
                    ),
                  );
                } else {
                  print("eror");
                }
              },
              child: Text("Hoàn thành xác nhận thông tin"),
            ),
          ],
        ),
      ),
    );
  }
}
