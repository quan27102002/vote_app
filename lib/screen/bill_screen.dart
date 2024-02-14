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
  BillCustomer? customer;
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
  void initState() {
    super.initState();
    // Không cần truy cập context ở đây
    // Đã chuyển việc gọi getApi() vào hàm build()
  }

  @override
  Widget build(BuildContext context) {
    // Gọi hàm getApi() trong hàm build() để đảm bảo context đã được khởi tạo
    if (_isLoading) {
      getApi();
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          if (customer != null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(customer!.hoTen ?? ""),
                  Text(selectedEmoji),
                  Text("Comments:"),
                  for (var comment in comments) Text(comment),
                  Text("Comment Difference: $commentDifference"),
                ],
              ),
            ),
          if (customer == null)
            Center(child: Text("Không tìm thấy khách hàng")),
          ElevatedButton(
              onPressed: () {}, child: Text("Hoàn thành xác nhận thông tin"))
        ],
      ),
    );
  }
}
