import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import 'package:vote_app/widget/emotion/model.dart';
import 'package:vote_app/widget/excel/helper/save_file_mobile_desktop.dart'
    if (dart.library.html) 'helper/save_file_web.dart' as helper;
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Duration? executionTime;
  List<HoaDon> hoaDonList = [];
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();






  Future<void> exportToExcel() async {
    final stopwatch = Stopwatch()..start();
    final apiUrl = 'http://103.226.249.65:8081/api/AppService';
    final requestBody = {
      "sid": null,
      "cmd": "API_DanhSachKhachHang_Select",
      "data": {
        "benhnhan": {"TuNgay": "20240101", "DenNgay": "20240103", "MaCoSo": ""}
      }
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        List responseObject = json.decode(response.body)["data"];
        for (var itemData in responseObject) {
          hoaDonList.add(HoaDon.fromJson(itemData));
        }
 final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    // Add headers
    sheet.getRangeByIndex(1, 1).setText('Họ và tên');
    sheet.getRangeByIndex(1, 2).setText('Mã bênh nhân');
    sheet.getRangeByIndex(1, 3).setText('Điện thoại di động');
    sheet.getRangeByIndex(1, 4).setText('Mã hóa đơn');
    sheet.getRangeByIndex(1, 5).setText('Thời gian khám');
    sheet.getRangeByIndex(1, 6).setText('Cơ sở khám');
    sheet.getRangeByIndex(1, 7).setText('Bác sĩ phụ trách');
    sheet.getRangeByIndex(1, 8).setText('Tên dịch vụ');
      sheet.getRangeByIndex(1, 9).setText('Số lượng');
    sheet.getRangeByIndex(1, 10).setText('Đơn giá');
       sheet.getRangeByIndex(1, 11).setText('Mã cơ sở');

    // Add data
    for (int i = 0; i < hoaDonList.length; i++) {
      sheet.getRangeByIndex(i + 2, 1).setText(hoaDonList[i].hoTen);
      sheet.getRangeByIndex(i + 2, 2).setText(hoaDonList[i].maBenhNhan);
      sheet.getRangeByIndex(i + 2, 3).setText(hoaDonList[i].dienThoaidD);
      sheet.getRangeByIndex(i + 2, 4).setNumber(hoaDonList[i].maHoaDon?.toDouble());
         sheet.getRangeByIndex(i + 2, 5).setText(hoaDonList[i].thoiGianKham);
      sheet.getRangeByIndex(i + 2, 6).setText(hoaDonList[i].coSoKham);
      sheet.getRangeByIndex(i + 2, 7).setText(hoaDonList[i].bacSyPhuTrach);
      sheet.getRangeByIndex(i + 2, 8).setText(hoaDonList[i].tenDichVu);
            sheet.getRangeByIndex(i + 2, 9).setNumber(hoaDonList[i].soLuong?.toDouble() );
      sheet.getRangeByIndex(i + 2, 10).setNumber(hoaDonList[i].donGia);
      sheet.getRangeByIndex(i + 2, 11).setText(hoaDonList[i].maCoSo);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    await helper.saveAndLaunchFile(bytes, 'hoaDonList.xlsx');
        setState(() {
          executionTime = stopwatch.elapsed;
        });
      } else {
        print('Lỗi: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Lỗi kết nối: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
      child:ElevatedButton(child: Text("export"),onPressed:exportToExcel ,)
      )  );
    

  }
}
 