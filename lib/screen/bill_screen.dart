import 'package:flutter/material.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/model/bill_customer.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({Key? key}) : super(key: key);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  late Map<String, dynamic> rateData;
  List<BillCustomer> listBill = [];
  late BillCustomer customer;
  late List<String> comments;
  late String selectedEmoji;
  late String commentDifference;
  bool _isLoading = true; // Biến để kiểm tra trạng thái đang tải dữ liệu

  Future<void> getApi() async {
    listBill.clear();
    ApiResponse res = await ApiRequest.getData();

    if (res.result == true) {
      setState(() {
        for (var e in res.data) {
          listBill.add(BillCustomer.fromJson(e));
        }
        for (int i = 0; i < listBill.length; i++) {
          if (listBill[i].maHoaDon == 1855175) {
            customer = listBill[i];
            break; // Thoát khỏi vòng lặp sau khi tìm thấy customer
          }
        }
        _isLoading = false; // Đã hoàn thành tải dữ liệu
      });
    } else {
      print(res.message ?? "Lỗi");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Call getApi() within build() for context access
    if (_isLoading) {
      getApi(); // Start data fetching when build executes
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Center(
        // Use Center widget effectively:
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertically center
          crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center
          children: [
            if (customer != null)
              Column(
                children: [
                  Text("Họ và tên: ${customer!.hoTen}"),
                  Text("Mã bệnh nhân: ${customer!.maBenhNhan}"),
                  Text("Số điện thoại:${customer!.dienThoaiDD}"),
                  Text("Mã hoá đơn:${customer!.maHoaDon}"),
                  Text("Thời gian khám:${customer?.thoiGianKham}"),
                  Text("Mã chi nhánh :${customer?.maCoSo}"),
                  Text("Địa chỉ khám:${customer?.coSoKham}"),
                  Text("Bác sĩ khám :${customer?.bacSyPhuTrach}"),
                  Text("Dịch vụ:"),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Tên dịch vụ: ${customer?.tenDichVu}"),
                      Text("Tên dịch vụ: ${customer?.soLuong}"),
                      Text("Tên dịch vụ: ${customer?.donGia}"),
                    ],
                  )
                ],
              ),
            if (customer == null) Text("Không tìm thấy khách hàng"),
            ElevatedButton(
              onPressed: () async {
                final res = await ApiRequest.uploadBillCustomer(
                  customer.maHoaDon ?? 0,
                  customer.hoTen ?? "",
                  customer.maBenhNhan ?? "",
                  customer.dienThoaiDD ?? "",
                  customer.thoiGianKham ?? "",
                  customer.maCoSo ?? "",
                  customer.coSoKham ?? "",
                  customer.bacSyPhuTrach ?? "",
                  customer.tenDichVu ?? "",
                  customer.soLuong ?? 0,
                  customer.donGia!.toInt(),
                );
                if (res.result == true) {
                  Navigator.pushReplacementNamed(context, '/home');
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
