import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;
import 'package:vote_app/model/model_excel.dart';

import 'package:vote_app/widget/excel/helper/save_file_mobile_desktop.dart'
    if (dart.library.html) 'package:vote_app/widget/excel/helper/save_file_web.dart'
    as helper;

class Excel extends StatefulWidget {
  const Excel({Key? key}) : super(key: key);

  @override
  _ExcelState createState() => _ExcelState();
}

class _ExcelState extends State<Excel> {
  String? _selectedOption;

  final Map<String, String> options = {
    '': 'Tất cả',
    'ND': 'Cơ sở Nguyễn Du',
    'BN': 'Cơ sở Bắc Ninh',
    'DH': 'Cơ sở Trần Duy Hưng',
    'TH': 'Cơ sở Thái Hà',
    'DN': 'Cơ sở Trần Đăng Ninh',
    'HL': 'Nha khoa Úc Châu 1',
    'UC': 'Nha khoa Úc Châu 2',
    'UB': 'Nha khoa Úc Châu 3',
    'HD': 'Cơ sở Hà Đông'
  };
  late String timeCreate;
  late String timeEnd;
  TextEditingController dateStartController = TextEditingController();
  TextEditingController dateEndController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Future<void> selectDateStart(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      String formatDated = DateFormat('dd/MM/yyyy').format(picked);
      timeCreate = await DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(picked);
      dateStartController.text = formatDated;
    }
  }

  Future<void> selectDateEnd(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      String formatDated = DateFormat('dd/MM/yyyy').format(picked);
      timeEnd = await DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(picked);
      dateEndController.text = formatDated;
    }
  }

  Duration? executionTime;
  List<HoaDon> hoaDonList = [];
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  Future<void> exportToExcel(
      String timeStart, String timeEnd, String place) async {
    final stopwatch = Stopwatch()..start();
    final apiUrl =
    'https://localhost:7257/api/Report/export';
    //  'http://103.226.249.65:8081/api/AppService';
     final SharedPreferences prefs = await SharedPreferences.getInstance();
                            final String? token = prefs.getString('jwt');
                            print(token);
    Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
    'accept': '*/*',
  };
    final requestBody = {
        "startTime":  "$timeStart",
        // "2024-02-14T19:17:19.453Z",
  "endTime":  "$timeEnd",
  // "2024-02-14T19:17:19.453Z",
  "branchCode":"$place"
  //  "string"

      // "sid": null,
      // "cmd": "API_DanhSachKhachHang_Select",
      // "data": {
      //   "benhnhan": {
      //     "TuNgay": "$timeStart",
      //     "DenNgay": "$timeEnd",
      //     "MaCoSo": "$place"
      //   }
      // }
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
           headers: headers,
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
        sheet.getRangeByIndex(1, 12).setText('Trạng thái cảm xúc');
        sheet.getRangeByIndex(1, 13).setText('Comment');

        // Add data
        for (int i = 0; i < hoaDonList.length; i++) {
          sheet.getRangeByIndex(i + 2, 1).setText(hoaDonList[i].hoTen);
          sheet.getRangeByIndex(i + 2, 2).setText(hoaDonList[i].maBenhNhan);
          sheet.getRangeByIndex(i + 2, 3).setText(hoaDonList[i].dienThoaidD);
          sheet
              .getRangeByIndex(i + 2, 4)
              .setNumber(hoaDonList[i].maHoaDon?.toDouble());
          sheet.getRangeByIndex(i + 2, 5).setText(hoaDonList[i].thoiGianKham);
          sheet.getRangeByIndex(i + 2, 6).setText(hoaDonList[i].coSoKham);
          sheet.getRangeByIndex(i + 2, 7).setText(hoaDonList[i].bacSyPhuTrach);
          sheet.getRangeByIndex(i + 2, 8).setText(hoaDonList[i].tenDichVu);
          sheet
              .getRangeByIndex(i + 2, 9)
              .setNumber(hoaDonList[i].soLuong?.toDouble());
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
        backgroundColor: Color.fromRGBO(47, 179, 178, 1),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Text(
              "Chi tiết đánh giá",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(0),
                      decoration: const BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          ),
                      child: TextFormField(
                        readOnly: true,
                        onTap: () {
                          selectDateStart(context);
                        },
                        controller: dateStartController,
                        textInputAction: TextInputAction.newline,
                        textAlignVertical: TextAlignVertical.bottom,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.black26)
                        // AppFonts.sf400(AppDimens.textSizeSmall, AppColors.bodyTextColor),

                        ,
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            margin: const EdgeInsets.only(left: 8, right: 8),
                            child: const ImageIcon(
                              AssetImage('assets/images/calendar.png'),
                              size: 24,
                            ),
                          ),
                          labelText: "Chọn ngày bắt đầu",
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 20, minHeight: 20),
                          prefixIconColor: Colors.black26,
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFFC7C9D9), width: 1),
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFC7C9D9),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color(0xFFC7C9D9),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(0),
                      decoration: const BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          ),
                      child: TextFormField(
                        readOnly: true,
                        onTap: () {
                          selectDateEnd(context);
                        },
                        controller: dateEndController,
                        textInputAction: TextInputAction.newline,
                        textAlignVertical: TextAlignVertical.bottom,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.black26)
                        // AppFonts.sf400(AppDimens.textSizeSmall, AppColors.bodyTextColor),

                        ,
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            margin: const EdgeInsets.only(left: 8, right: 8),
                            child: const ImageIcon(
                              AssetImage('assets/images/calendar.png'),
                              size: 24,
                            ),
                          ),
                          labelText: "Đến ngày",
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 20, minHeight: 20),
                          prefixIconColor: Colors.black26,
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFFC7C9D9), width: 1),
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFC7C9D9),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: Color(0xFFC7C9D9),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: DropdownButtonFormField<String>(
                value: _selectedOption,
                items: options.keys.map((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(options[key]!),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Chọn chi nhánh",
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  enabledBorder: InputBorder.none,
                ),
                dropdownColor: Colors.white,
              ),
            ),
            SizedBox(height: 35),
            ElevatedButton(
              onPressed: () {
                print(timeEnd + timeCreate);
                print(_selectedOption);
                exportToExcel(timeCreate, timeEnd, _selectedOption!);
              },
              child: Text("Xem thông tin với excel"),
            )
          ]),
        ));
  }
}
