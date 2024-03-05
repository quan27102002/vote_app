import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row,Stack;
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/dialog/funtion.dart';
import 'package:vote_app/model/modelFilter.dart';
import 'package:vote_app/provider/loading.dart';
import 'package:vote_app/provider/userProvider.dart';
import 'package:vote_app/router/router_name.dart';
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
_loadRole();
    exportToChart(
        widget.timeCreate, widget.timeEnd, widget.selectedOption, widget.index);
  }
  int? role;
   Future<void> _loadRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getInt('role')!;
    });
  }
  @override
  Widget build(BuildContext context) {
    // Lấy tham số từ route arguments
 final loadingProvider = Provider.of<LoadingProvider>(context);
    return Scaffold(
      drawer: Drawer(
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
              role==1?   ListTile(
              leading: Icon(Icons.person),
              title: Text('Xem các tài khoản'),
              onTap: () {
                // Add your logic here for Button 1
                Navigator.pushNamed(context, RouteName.readuser,
                    arguments: false);
              },
            ):Container(height: 0,),
          role==1?  ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Tạo tài khoản'),
              onTap: () {
                // Add your logic here for Button 1
                Navigator.pushNamed(context, RouteName.create,
                    arguments: false);
              },
            ):Container(),
            ListTile(
              leading: Icon(Icons.insert_chart),
              title: Text('Xem biểu đồ thống kê'),
              onTap: () {
            
                Navigator.pushNamed(context, RouteName.chart,
                    arguments: false);
              },
            ),
            role==1?  ListTile(
              leading: Icon(Icons.settings),
              title: Text('Chỉnh sửa comment'),
              onTap: () {
               
                Navigator.pushNamed(context, RouteName.editComment,
                    arguments: false);
              },
            ):Container(height: 0,),
            ListTile(
              leading: Icon(Icons.file_download),
              title: Text('Xuất file excel'),
              onTap: () {
                // Add your logic here for Button 3
                Navigator.pushNamed(context, RouteName.excel);
              },
            ),
               role==1?  ListTile(
              leading: Icon(Icons.image),
              title: Text('Chỉnh sửa file đa phương tiện'),
              onTap: () {
               
                Navigator.pushNamed(context, RouteName.editMedia,
                    arguments: false);
              },
            ):Container(height: 0,),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Đăng xuất'),
              onTap: () async {
                // Add your logic here for Button 4
          
                  SharedPreferences prefs = await SharedPreferences.getInstance();
             await   Provider.of<UserProvider>(context, listen: false).logout();
                 await prefs.remove('jwt'); 
               Navigator.pushNamedAndRemoveUntil(context, RouteName.login,(Route<dynamic> route) => false,);
              },
            ),
          ],
        ),
      ),
    appBar: AppBar(backgroundColor: Color.fromRGBO(47, 179, 178, 1) ,title: Center(child: Text("Chi tiết các đánh giá", style: TextStyle(
                        fontFamily: 'SF Pro Rounded',
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ))),),
   body: Stack(
     children:[Padding(
       padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
       child: ListView.builder(
         itemCount: userComments.length + otherComments.length,
         itemBuilder: (context, index) {
        var comment;
        var onTapFunction;
        if (index < userComments.length) {
          comment = userComments[index];
          onTapFunction = () {
            AppFuntion.showDialogError(context, '', onPressButton: () {
              excelFiter(comment['content']);
            },
            textButton: "Xem chi tiết",
            title:"Thông tin của những người đánh giá" ,
            description: comment['content'],
            dialogDismiss: true);
          };
        } else {
          comment = otherComments[index - userComments.length];
          onTapFunction = () {
            AppFuntion.showDialogError(context, '', onPressButton: () {
              excelFiter2(comment['content']);
            },
            textButton: "Xem chi tiết",
            title: "Thông tin của những người đánh giá",
            description: comment['content'],
            dialogDismiss: true);
          };
        }
       
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            color: Colors.grey[200], // Màu nền của mỗi dòng
            borderRadius: BorderRadius.circular(10.0), // Bo góc
          ),
          child: ListTile(
            onTap: onTapFunction,
            title: Text(comment['content']),
            subtitle: Text(comment['count'].toString()+" Lượt đánh giá",style: TextStyle(fontWeight: FontWeight.w600),),
          ),
        );
         },
       ),
     ),
      if (loadingProvider.isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
     ] 
   ),

    );
  }

  Future<void> exportToChart(
      String createTime, String timend, String place, int level) async {
    final loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
 loadingProvider.showLoading();
    ApiResponse res = await ApiRequest.getfilterTotalComment(
        createTime, timend, place, level);
    if (res.code == 200) {
      loadingProvider.hideLoading();
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
           sheet.getRangeByIndex(1, 7).setText('Tên cơ sở');
        sheet.getRangeByIndex(1, 8).setText('Bác sĩ');
        sheet.getRangeByIndex(1, 9).setText('Dịch vụ');

        // Add data
        for (int i = 0; i < invoices.length; i++) {
          final Invoice invoice = invoices[i];
          sheet
              .getRangeByIndex(i + 2, 1)
              .setText(invoice.billCode);
             sheet.getRangeByIndex(i + 2, 2).setText(invoice.customerName);
          sheet.getRangeByIndex(i + 2, 3).setText(invoice.customerCode);
          sheet.getRangeByIndex(i + 2, 4).setText(invoice.phone);
          sheet.getRangeByIndex(i + 2, 5).setText(invoice.startTime);
          sheet.getRangeByIndex(i + 2, 6).setText(invoice.branchCode);
           sheet.getRangeByIndex(i + 2,7 ).setText(invoice.branchAddress);
          sheet.getRangeByIndex(i + 2, 8).setText(invoice.doctor);

          // Extract service information from the Service object and display it
          final Service service = invoice.service;
          final String fullServiceInfo =
              '${service.name} - ${service.amount} - ${service.unitPrice}';
          sheet.getRangeByIndex(i + 2, 9).setText(fullServiceInfo);
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
     AppFuntion.showDialogError(context, "", onPressButton: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
            textButton: "Thoát",
            title: "Thông báo lỗi",
            description: "\t\t" +
                    res.code +
                    "\nLoad dữ liệu lỗi" ??
                "Vui lòng đăng xuất");
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
      final List<dynamic> otherComments = data['otherComments'];

      // Tìm phần tử trong danh sách otherComments có nội dung trùng với comment
      var foundComment = otherComments.firstWhere(
        (element) => element['content'] == comment,
        orElse: () => null,
      );

      if (foundComment != null) {
        final Map<String, dynamic> createdBy = foundComment['createdBy'] ?? {};

        final List<Invoice> invoices = [];

        if (createdBy != {}) {
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
           sheet.getRangeByIndex(1, 7).setText('Tên cơ sở');
        sheet.getRangeByIndex(1, 8).setText('Bác sĩ');
        sheet.getRangeByIndex(1, 9).setText('Dịch vụ');

        // Add data
        for (int i = 0; i < invoices.length; i++) {
          final Invoice invoice = invoices[i];
          sheet
              .getRangeByIndex(i + 2, 1)
              .setText(invoice.billCode);
          sheet.getRangeByIndex(i + 2, 2).setText(invoice.customerName);
          sheet.getRangeByIndex(i + 2, 3).setText(invoice.customerCode);
          sheet.getRangeByIndex(i + 2, 4).setText(invoice.phone);
          sheet.getRangeByIndex(i + 2, 5).setText(invoice.startTime);
          sheet.getRangeByIndex(i + 2, 6).setText(invoice.branchCode);
           sheet.getRangeByIndex(i + 2,7 ).setText(invoice.branchAddress);
          sheet.getRangeByIndex(i + 2, 8).setText(invoice.doctor);

          // Extract service information from the Service object and display it
          final Service service = invoice.service;
          final String fullServiceInfo =
              '${service.name} - ${service.amount} - ${service.unitPrice}';
          sheet.getRangeByIndex(i + 2, 9).setText(fullServiceInfo);
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
