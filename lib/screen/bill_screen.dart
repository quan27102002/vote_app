import 'package:flutter/material.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/model/bill_customer.dart';
import 'package:intl/intl.dart';
import 'package:vote_app/model/id_bill_customer.dart';
import 'package:vote_app/screen/home_screen.dart';
import 'package:vote_app/widget/row_in_card_product.dart';

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
  NumberFormat? formatter;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getApi(int.parse(widget.data));
    });
  }

  String formatCurrency(int number) {
    formatter = NumberFormat.currency(locale: 'vi', symbol: '₫');
    return formatter!.format(number);
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
    double width = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HOÁ ĐƠN DỊCH VỤ",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Canh giữa tiêu đề
        leading: Container(
          margin: EdgeInsets.only(top: 20),
          child: Image.asset(
            "assets/images/logo_uc.png",
            fit: BoxFit.contain, // Đảm bảo kích thước ảnh vừa với container
          ),
        ),
        leadingWidth: 100,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: width * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    RowInCardProduct(
                      titleLeft: "Mã hoá đơn",
                      titleRight: customer.maHoaDon.toString(),
                    ),
                    RowInCardProduct(
                      titleLeft: "Tên khách hàng",
                      titleRight: customer.hoTen,
                    ),
                    RowInCardProduct(
                      titleLeft: "Mã khách hàng",
                      titleRight: customer.maBenhNhan,
                    ),
                    RowInCardProduct(
                      titleLeft: "Mã cơ sở",
                      titleRight: customer.maCoSo,
                    ),
                    RowInCardProduct(
                      titleLeft: "Địa chỉ",
                      titleRight: customer.coSoKham,
                    ),
                    RowInCardProduct(
                      titleLeft: "Tên bác sĩ",
                      titleRight: customer.bacSyPhuTrach,
                    ),
                    RowInCardProduct(
                      titleLeft: "Dịch vụ",
                      titleRight: customer.tenDichVu,
                    ),
                    RowInCardProduct(
                      titleLeft: "Số lượng",
                      titleRight: customer.soLuong.toString(),
                    ),
                    RowInCardProduct(
                      titleLeft: "Đơn giá",
                      titleRight: formatCurrency(customer.donGia!.toInt()),
                    ),
                    RowInCardProduct(
                      titleLeft: "Số điện thoại",
                      titleRight: customer.dienThoaiDD,
                    ),
                    RowInCardProduct(
                      titleLeft: "Thời gian khám",
                      titleRight: customer.thoiGianKham,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: width * 0.3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color.fromRGBO(47, 179, 178, 1) // Màu của nút
                        ),
                    onPressed: () async {
                      DateFormat currentFormat =
                          DateFormat("dd/MM/yyyy HH:mm:ss");
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
                    child: Text(
                      "Xác nhận hoá đơn",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
