import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/dialog/funtion.dart';
import 'package:vote_app/model/modelFilter.dart';
import 'package:vote_app/widget/excel/helper/save_file_mobile_desktop.dart'
    if (dart.library.html) 'package:vote_app/widget/excel/helper/save_file_web.dart'
    as helper;
class MyListViewScreen extends StatefulWidget {
  final String timeCreate;
  final String timeEnd;
  final String selectedOption;
  final int index;

  const MyListViewScreen(
      {super.key,
      required this.timeCreate,
      required this.timeEnd,
      required this.selectedOption,
      required this.index});
  @override
  State<MyListViewScreen> createState() => _MyListViewScreenState();
}

class _MyListViewScreenState extends State<MyListViewScreen> {
  List<dynamic> userComments = [];
  List<dynamic> otherComments = [];
    Duration? executionTime;
    List<Invoice> userFilter = [];
@override
void initState() {
  super.initState();
  exportToChart(widget.timeCreate, widget.timeEnd,
                  widget.selectedOption, widget.index);
}
 @override
Widget build(BuildContext context) {
  // Lấy tham số từ route arguments

  return Scaffold(
    appBar: AppBar(
      title: Text('Chi tiết các đánh giá'),
      backgroundColor: Colors.blue, // Đặt màu cho AppBar
    ),
    body: ListView.separated(
      itemCount: userComments.length + otherComments.length,
      separatorBuilder: (context, index) => Divider(), // Sử dụng Divider() để ngăn cách giữa các hàng
      itemBuilder: (context, index) {
        if (index < userComments.length) {
          var comment = userComments[index];
          return ListTile(
            onTap: () {
             AppFuntion.showDialogError(context, '', onPressButton: () {
         excelFiter(comment['content']);
              },
                  textButton: "Xem chi tiết",
                  title: comment['content'],
                  description: "Thông tin của những người đánh giá",
                  dialogDismiss: true);
            },
            title: Text(comment['content']),
          );
        } else {
          var comment = otherComments[index - userComments.length];
          return ListTile(
            onTap: () {
              AppFuntion.showDialogError(context, '', onPressButton: () {
         excelFiter2(comment['content']);
              },
                  textButton: "Xem chi tiết",
                  title: comment['content'],
                  description: "Thông tin của những người đánh giá",
                  dialogDismiss: true);
            },
            title: Text(comment['content']),
          );
        }
      },
    ),
  );
}


  Future<void> exportToChart(
      String createTime, String timend, String place, int level) async {
    ApiResponse res = await ApiRequest.getfilterTotalComment(
        createTime, timend, place, level);
    if (res.code == 200) {
      List<dynamic> userData = res.data['userComments'];
      List<dynamic> otherData = res.data['otherComments'];

      // Thêm dữ liệu vào userComments và otherComments
setState(() {
        userComments.clear();
        otherComments.clear();
        userComments.addAll(userData);
        otherComments.addAll(otherData);
      });
    }
  }

Future<void> excelFiter(String comment) async {
  ApiResponse res = await ApiRequest.getfilterTotalComment(
    widget.timeCreate, 
    widget.timeEnd,
    widget.selectedOption, 
    widget.index,
  );

  final stopwatch = Stopwatch()..start();

  if (res.code == 200) {
    final Map<String, dynamic> data = res.data;
    final List<dynamic> userComments = data['userComments'];

    // Tìm phần tử trong danh sách userComments có nội dung trùng với comment
    var foundComment = userComments.firstWhere(
      (element) => element['content'] == comment,
      orElse: () => null,
    );

    if (foundComment != null) {
      final List<dynamic> userData = foundComment['createdBy'] ?? [];
      final List<Invoice> invoices = [];

      for (var itemData in userData) {
        final Invoice invoice = Invoice.fromJson(itemData);
        invoices.add(invoice);
      }

      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      // Add headers
      sheet.getRangeByIndex(1, 1).setText('Mã hóa đơn');
      sheet.getRangeByIndex(1, 2).setText('Tên khách hàng');
      sheet.getRangeByIndex(1, 3).setText('Mã khách hàng');
      sheet.getRangeByIndex(1, 4).setText('Số điện thoại');
      sheet.getRangeByIndex(1, 5).setText('Thời gian khám'); 
      sheet.getRangeByIndex(1, 6).setText('Mã cơ sở');
      sheet.getRangeByIndex(1, 7).setText('Bác sĩ');
      sheet.getRangeByIndex(1, 8).setText('Dịch vụ');

      // Add data
      for (int i = 0; i < invoices.length; i++) {
        final Invoice invoice = invoices[i];
        sheet.getRangeByIndex(i + 2, 1).setNumber(invoice.billCode.toDouble());
        sheet.getRangeByIndex(i + 2, 2).setText(invoice.customerName);
        sheet.getRangeByIndex(i + 2, 3).setText(invoice.customerCode);
        sheet.getRangeByIndex(i + 2, 4).setText(invoice.branchCode);
        sheet.getRangeByIndex(i + 2, 5).setText(invoice.startTime);
        sheet.getRangeByIndex(i + 2, 6).setText(invoice.phone);
        sheet.getRangeByIndex(i + 2, 7).setText(invoice.doctor);
        
        // Extract service information from the Service object and display it
        final Service service = invoice.service;
        final String fullServiceInfo = '${service.name} - ${service.amount} - ${service.unitPrice}';
        sheet.getRangeByIndex(i + 2, 8).setText(fullServiceInfo);
      }

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      await helper.saveAndLaunchFile(bytes, 'khachhanglist.xlsx');
      setState(() {
        executionTime = stopwatch.elapsed;
      });
    } else {
      print('Không tìm thấy phản hồi có nội dung là: $comment');
    }
  } else {
    print('Lỗi: ${res.code}');
  }
}
Future<void> excelFiter2(String comment) async {
  ApiResponse res = await ApiRequest.getfilterTotalComment(
    widget.timeCreate, 
    widget.timeEnd,
    widget.selectedOption, 
    widget.index,
  );

  final stopwatch = Stopwatch()..start();

  if (res.code == 200) {
    final Map<String, dynamic> data = res.data;
    final List<dynamic> otherComments = data['otherComments'] ;

    // Tìm phần tử trong danh sách otherComments có nội dung trùng với comment
    var foundComment = otherComments.firstWhere(
      (element) => element['content'] == comment,
      orElse: () => null,
    );

    if (foundComment != null) {
      final Map<String, dynamic> createdBy = foundComment['createdBy'] ?? {};
     
      final List<Invoice> invoices = [];

      if(createdBy!={}) {
        final Invoice invoice = Invoice.fromJson(createdBy);
        invoices.add(invoice);
      }

      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];

      // Add headers
      sheet.getRangeByIndex(1, 1).setText('Mã hóa đơn');
      sheet.getRangeByIndex(1, 2).setText('Tên khách hàng');
      sheet.getRangeByIndex(1, 3).setText('Mã khách hàng');
      sheet.getRangeByIndex(1, 4).setText('Số điện thoại');
      sheet.getRangeByIndex(1, 5).setText('Thời gian khám'); 
      sheet.getRangeByIndex(1, 6).setText('Mã cơ sở');
      sheet.getRangeByIndex(1, 7).setText('Bác sĩ');
      sheet.getRangeByIndex(1, 8).setText('Dịch vụ');

      // Add data
      for (int i = 0; i < invoices.length; i++) {
        final Invoice invoice = invoices[i];
        sheet.getRangeByIndex(i + 2, 1).setNumber(invoice.billCode.toDouble());
        sheet.getRangeByIndex(i + 2, 2).setText(invoice.customerName);
        sheet.getRangeByIndex(i + 2, 3).setText(invoice.customerCode);
        sheet.getRangeByIndex(i + 2, 4).setText(invoice.branchCode);
        sheet.getRangeByIndex(i + 2, 5).setText(invoice.startTime);
        sheet.getRangeByIndex(i + 2, 6).setText(invoice.phone);
        sheet.getRangeByIndex(i + 2, 7).setText(invoice.doctor);
        
        // Extract service information from the Service object and display it
        final Service service = invoice.service;
        final String fullServiceInfo = '${service.name} - ${service.amount} - ${service.unitPrice}';
        sheet.getRangeByIndex(i + 2, 8).setText(fullServiceInfo);
      }

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      await helper.saveAndLaunchFile(bytes, 'khachhanglist.xlsx');
      setState(() {
        executionTime = stopwatch.elapsed;
      });
    } else {
      print('Không tìm thấy phản hồi có nội dung là: $comment');
    }
  } else {
    print('Lỗi: ${res.code}');
  }
}

}