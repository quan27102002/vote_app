import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/dialog/funtion.dart';
import 'package:vote_app/model/bill_customer.dart';
import 'package:intl/intl.dart';
import 'package:vote_app/model/id_bill_customer.dart';
import 'package:vote_app/provider/userProvider.dart';
import 'package:vote_app/router/router_name.dart';
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
  List<BillCustomer> service = [];
  List<Map<String, dynamic>> services = [];
  String? userBillId;
  late BillCustomer customer;
  bool _isLoading = true;
  NumberFormat? formatter;

  @override
  void initState() {
    super.initState();

    getApi(widget.data);
  }

  String formatCurrency(int number) {
    formatter = NumberFormat.currency(locale: 'vi', symbol: '₫');
    return formatter!.format(number);
  }

  Future<void> getApi(String idBill) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? codeBr = prefs.getString('codeBr');
    ApiResponse res = await ApiRequest.getData(codeBr);
    if (res.result == true) {
      List<BillCustomer> listBill = [];
      for (var e in res.data) {
        listBill.add(BillCustomer.fromJson(e));
      }

      // Kiểm tra xem có phần tử nào thỏa mãn điều kiện không
      var matchingBills =
          listBill.where((bill) => bill.maHoaDon == idBill).toList();

      if (matchingBills.isNotEmpty) {
        setState(() {
          service.addAll(matchingBills);
          _isLoading = false;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Thông báo'),
              content: Text('Hoá đơn này không tồn tại'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        print("Không tìm thấy hóa đơn có mã $idBill");
      }
    } else if (res.code == 401 && res.status == 1000) {
      AppFuntion.showDialogError(context, "", onPressButton: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        await Provider.of<UserProvider>(context, listen: false).logout();
        await prefs.remove('jwt');
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.login,
          (Route<dynamic> route) => false,
        );
      },
          textButton: "Đăng xuất",
          title: "Thông báo lỗi",
          description: "\t\t" +
                  "\nTài khoản vừa đăng nhập trên thiết bị khác,vui lòng đăng xuất" ??
              "Vui lòng nhập lại tên và mật khẩu");
    } else {
      print(res.message ?? "Lỗi");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "HOÁ ĐƠN DỊCH VỤ",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
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
                      titleRight: service[0].maHoaDon,
                    ),
                    RowInCardProduct(
                      titleLeft: "Tên khách hàng",
                      titleRight: service[0].hoTen,
                    ),
                    RowInCardProduct(
                      titleLeft: "Mã khách hàng",
                      titleRight: service[0].maBenhNhan,
                    ),
                    RowInCardProduct(
                      titleLeft: "Mã cơ sở",
                      titleRight: service[0].maCoSo,
                    ),
                    RowInCardProduct(
                      titleLeft: "Địa chỉ",
                      titleRight: service[0].coSoKham,
                    ),
                    RowInCardProduct(
                      titleLeft: "Số điện thoại",
                      titleRight: service[0].dienThoaiDD,
                    ),
                    RowInCardProduct(
                      titleLeft: "Thời gian khám",
                      titleRight: service[0].thoiGianKham!.split(" ")[0],
                    ),
                    Container(
                      width: width,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: service.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                RowInCardProduct(
                                  titleLeft: "Dịch vụ",
                                  titleRight: service[index].tenDichVu,
                                ),
                                // RowInCardProduct(
                                //   titleLeft: "Số lượng",
                                //   titleRight: service[index].soLuong.toString(),
                                // ),
                                RowInCardProduct(
                                  titleLeft: "Đơn giá",
                                  titleRight: formatCurrency(
                                      service[index].donGia!.toInt()),
                                ),
                                RowInCardProduct(
                                  titleLeft: "Tên bác sĩ",
                                  titleRight: service[index].bacSyPhuTrach,
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color.fromRGBO(47, 179, 178, 1) // Màu của nút
                        ),
                    onPressed: () async {
                      DateFormat currentFormat =
                          DateFormat("dd/MM/yyyy HH:mm:ss");
                      DateTime dateTime =
                          currentFormat.parse(service[0].thoiGianKham ?? '');

                      DateFormat newFormat =
                          DateFormat("yyyy-MM-dd'T'HH:mm:ss.000'Z'");
                      String newDateTimeString = newFormat.format(dateTime);
                      for (int i = 0; i < service.length; i++) {
                        services.add({
                          "doctor": service[i].bacSyPhuTrach,
                          "name": service[i].tenDichVu,
                          "amount": service[i].soLuong,
                          "uniPrice": service[i].donGia
                        });
                      }

                      final res = await ApiRequest.uploadBillCustomer(
                        service[0].maHoaDon ?? "",
                        service[0].hoTen ?? "",
                        service[0].maBenhNhan ?? "",
                        service[0].dienThoaiDD ?? "",
                        newDateTimeString,
                        service[0].maCoSo ?? "",
                        service[0].coSoKham ?? "",
                        services,
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
