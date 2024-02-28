import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
import 'package:vote_app/provider/userProvider.dart';
import 'dart:math' as math;

import 'package:vote_app/router/router_name.dart';
import 'package:vote_app/screen/totalComment.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<double> percentages = [];
  List<double> percentagesType = [];
  List<_BarData> dataList = [
    const _BarData(Colors.red, 0),
    const _BarData(Colors.orange, 0),
    const _BarData(Colors.yellow, 0),
    const _BarData(Colors.green, 0),
    const _BarData(Colors.pink, 0),
  ];

  int? role;
  String? checktype;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  String? _selectedOption;

  final Map<String, String> optionFilter = {
    '1': 'Xem chi tiết theo từng trạng thái cảm xúc',
    '2': 'Xem theo chế độ tích cực,tiêu cực'
  };
  Future<void> _loadRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getInt('role')!;
    });
  }

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
  int touchedIndex = 0;

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

  List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.pink,
  ];
  List<Color> colorsType = [
    Colors.red,
    Colors.green,
  ];
  // Danh sách chú thích cho các cảm xúc
  final List<String> emotions = [
    'Rất Tệ',
    'Tệ',
    'Bình thường',
    'Tốt',
    'Hoàn hảo',
  ];
  List<String> emotions1 = [];
  List<String> emotionsType = [];
  final List<String> emotionsType1 = ["Tiêu cực", "Tích cực"];
  BarChartGroupData generateBarGroup(
    int x,
    Color color,
    double value,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: 6,
        ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }

  Future<void> exportToChart(
      String createTime, String timend, String place) async {
    ApiResponse res =
        await ApiRequest.getTotalComment(createTime, timend, place);
    print(res);
    print(res.headers);
    if (res.code == 200) {
      List<dynamic> data = res.data;
      List<double> percentages = [];

      for (var item in data) {
        // Kiểm tra xem trường count có tồn tại và có kiểu số không
        if (item['count'] is num) {
          // Ép kiểu và thêm vào danh sách percentages
          percentages.add(item['count'].toDouble());
        }
      }
      double sumFirstTwo = percentages
          .take(2)
          .fold(0, (previous, current) => previous + current);

      double sumLastThree = percentages
          .skip(2)
          .fold(0, (previous, current) => previous + current);

      List<double> result = [sumFirstTwo, sumLastThree];
      List<String> resultPercel = [
        (sumFirstTwo / (sumFirstTwo + sumLastThree) * 100).toStringAsFixed(2),
        (100 - sumFirstTwo * 100 / (sumFirstTwo + sumLastThree))
            .toStringAsFixed(2)
      ];

      List<String> percentTypeEmotion = [];
      double total = 0;
      List<_BarData> newDataList = [];
      for (int i = 0; i < percentages.length && i < colors.length; i++) {
        newDataList.add(_BarData(colors[i], percentages[i]));
        total += percentages[i];
      }
      print(total);
      double toltal2 = 0.0;
      for (int i = 0; i < percentages.length && i < colors.length; i++) {
        if (i < percentages.length - 1) {
          percentTypeEmotion
              .add((percentages[i] * 100 / total).toStringAsFixed(2));
          toltal2 += (percentages[i] * 100 / total);
        } else if (i == percentages.length - 1) {
          percentTypeEmotion.add((100.0 - toltal2).toStringAsFixed(2));
        }
      }

      setState(() {
        this.percentages = percentages;
        this.percentagesType = result;
        this.emotionsType = resultPercel;
        dataList = newDataList;
        this.emotions1 = percentTypeEmotion;
      });
    }
  }

  int touchedGroupIndex = -1;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
            role == 1
                ? ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Xem các tài khoản'),
                    onTap: () {
                      // Add your logic here for Button 1
                      Navigator.pushNamed(context, RouteName.readuser,
                          arguments: false);
                    },
                  )
                : Container(
                    height: 0,
                  ),
            role == 1
                ? ListTile(
                    leading: Icon(Icons.person_add),
                    title: Text('Tạo tài khoản'),
                    onTap: () {
                      // Add your logic here for Button 1
                      Navigator.pushNamed(context, RouteName.create,
                          arguments: false);
                    },
                  )
                : Container(height: 0),
            ListTile(
              leading: Icon(Icons.insert_chart),
              title: Text('Xem biểu đồ thống kê'),
              onTap: () {
                // Add your logic here for Button 2
                Navigator.pushNamed(context, RouteName.chart, arguments: false);
              },
            ),
            role == 1
                ? ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Chỉnh sửa comment'),
                    onTap: () {
                      // Add your logic here for Button 2
                      Navigator.pushNamed(context, RouteName.editComment,
                          arguments: false);
                    },
                  )
                : Container(
                    height: 0,
                  ),
            ListTile(
              leading: Icon(Icons.file_download),
              title: Text('Xuất file excel'),
              onTap: () {
                // Add your logic here for Button 3
                Navigator.pushNamed(context, RouteName.excel);
              },
            ),
            role == 1
                ? ListTile(
                    leading: Icon(Icons.image),
                    title: Text('Chỉnh sửa file đa phương tiện'),
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.editMedia,
                          arguments: false);
                    },
                  )
                : Container(
                    height: 0,
                  ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Đăng xuất'),
              onTap: () async {
                // Add your logic here for Button 4

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
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(47, 179, 178, 1),
        title: Center(
            child: Text("Biểu đồ thống kê",
                style: TextStyle(
                  fontFamily: 'SF Pro Rounded',
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ))),
      ),
      // backgroundColor: Color.fromRGBO(47, 179, 178, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Lọc đánh giá",
                      style: TextStyle(
                        fontFamily: 'SF Pro Rounded',
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonFormField<String>(
                  value: checktype,
                  items: optionFilter.keys.map((String key) {
                    return DropdownMenuItem<String>(
                      value: key,
                      child: Text(optionFilter[key]!),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      checktype = value;
                      print(value);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Lọc đánh giá",
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    enabledBorder: InputBorder.none,
                  ),
                  dropdownColor: Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Bắt đầu",
                                style: TextStyle(
                                  fontFamily: 'SF Pro Rounded',
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Container(
                            height: 50,
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
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
                                  fontSize: 18,
                                  color: Colors.black)
                              // AppFonts.sf400(AppDimens.textSizeSmall, AppColors.bodyTextColor),

                              ,
                              decoration: InputDecoration(
                                prefixIcon: Container(
                                  margin:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: const ImageIcon(
                                    AssetImage('assets/images/calendar.png'),
                                    size: 24,
                                  ),
                                ),

                                prefixIconConstraints: const BoxConstraints(
                                    minWidth: 20, minHeight: 20),
                                prefixIconColor: Colors.black,
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 28, 29, 31),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(12)),
                                // focusedBorder: OutlineInputBorder(
                                //     borderSide: const BorderSide(
                                //       color: Color(0xFFC7C9D9),
                                //       width: 1,
                                //     ),
                                //     borderRadius: BorderRadius.circular(12)),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Kết thúc",
                                style: TextStyle(
                                  fontFamily: 'SF Pro Rounded',
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Container(
                            height: 50,
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
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
                                  fontSize: 18,
                                  color: Colors.black)
                              // AppFonts.sf400(AppDimens.textSizeSmall, AppColors.bodyTextColor),

                              ,
                              decoration: InputDecoration(
                                prefixIcon: Container(
                                  margin:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: const ImageIcon(
                                    AssetImage('assets/images/calendar.png'),
                                    size: 24,
                                  ),
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                    minWidth: 20, minHeight: 20),
                                prefixIconColor: Colors.black,
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 25, 26, 29),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(12)),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              role == 1
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
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
                    )
                  : Container(),

              SizedBox(height: 15),

              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color.fromRGBO(47, 179, 178, 1) // Màu của nút
                      ),
                  onPressed: () async {
                    // login();
                    print(timeEnd + timeCreate);
                    print(_selectedOption);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    role = prefs.getInt('role')!;
                    String? codeBr = prefs.getString('codeBr');
                    if (role == 2) {
                      exportToChart(timeCreate, timeEnd, codeBr!);
                    } else {
                      exportToChart(timeCreate, timeEnd, _selectedOption!);
                    }
                  },
                  child: Text(
                    "Xem biểu đồ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              checktype == '1'
                  ? role == 1 && _selectedOption == ''
                      ? Container(
                          width: 300,
                          height: 300,
                          child: PieChart(
                            PieChartData(
                              sections: List.generate(
                                percentages.length,
                                (index) => PieChartSectionData(
                                  color: colors[index],
                                  value: percentages[index],
                                  title: emotions1[index] + "%",
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 300,
                          width: width * 0.7,
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: AspectRatio(
                              aspectRatio: 1.4,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceBetween,
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border.symmetric(
                                      horizontal: BorderSide(
                                          color: const Color.fromARGB(
                                              137, 235, 119, 119)),
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    leftTitles: AxisTitles(
                                      drawBelowEverything: true,
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toInt().toString(),
                                            textAlign: TextAlign.left,
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 36,
                                        getTitlesWidget: (value, meta) {
                                          final index = value.toInt();
                                          return SideTitleWidget(
                                            axisSide: meta.axisSide,
                                            child: _IconWidget(
                                              color: dataList[index].color,
                                              isSelected:
                                                  touchedGroupIndex == index,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    rightTitles: const AxisTitles(),
                                    topTitles: const AxisTitles(),
                                  ),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    getDrawingHorizontalLine: (value) => FlLine(
                                      color: const Color.fromARGB(
                                          137, 235, 119, 119),
                                      strokeWidth: 1,
                                    ),
                                  ),
                                  barGroups: dataList.asMap().entries.map((e) {
                                    final index = e.key;
                                    final data = e.value;
                                    return generateBarGroup(
                                      index,
                                      data.color,
                                      data.value,
                                    );
                                  }).toList(),
                                  maxY: getMaxValue(dataList) + 10,
                                  barTouchData: BarTouchData(
                                    enabled: true,
                                    handleBuiltInTouches: false,
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipBgColor: Colors.transparent,
                                      tooltipMargin: 0,
                                      getTooltipItem: (
                                        BarChartGroupData group,
                                        int groupIndex,
                                        BarChartRodData rod,
                                        int rodIndex,
                                      ) {
                                        return BarTooltipItem(
                                          rod.toY.toString(),
                                          TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: rod.color,
                                            fontSize: 18,
                                          ),
                                        );
                                      },
                                    ),
                                    touchCallback: (event, response) {
                                      if (event.isInterestedForInteractions &&
                                          response != null &&
                                          response.spot != null) {
                                        setState(() {
                                          touchedGroupIndex = response
                                              .spot!.touchedBarGroupIndex;
                                        });
                                      } else {
                                        setState(() {
                                          touchedGroupIndex = -1;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                  : Container(
                      width: 300,
                      height: 300,
                      child: PieChart(
                        PieChartData(
                          sections: List.generate(
                            percentagesType.length,
                            (index) => PieChartSectionData(
                              color: colorsType[index],
                              value: percentagesType[index],
                              title: emotionsType[index].toString() + "%",
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              // Danh sách chú thích
              checktype == '1'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        emotions.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: InkWell(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              role = prefs.getInt('role')!;
                              String? codeBr = prefs.getString('codeBr');
                              if (role == 2) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyListViewScreen(
                                        index: index,
                                        timeCreate: timeCreate,
                                        timeEnd: timeEnd,
                                        selectedOption: codeBr!),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyListViewScreen(
                                      index: index,
                                      timeCreate: timeCreate,
                                      timeEnd: timeEnd,
                                      selectedOption:
                                          _selectedOption.toString(),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  color: colors[index],
                                ),
                                SizedBox(width: 8),
                                Text(emotions[index]),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        emotionsType.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                color: colorsType[index],
                              ),
                              SizedBox(width: 8),
                              Text(emotionsType1[index]),
                            ],
                          ),
                        ),
                      ),
                    ),
              //  :Container(),
            ],
          ),
        ),
      ),
    );
  }

  double getMaxValue(List<_BarData> dataList) {
    double max = 0;
    for (_BarData data in dataList) {
      if (data.value > max) {
        max = data.value;
      }
    }
    return max;
  }
}

class _BarData {
  const _BarData(this.color, this.value);
  final Color color;
  final double value;
}

class _IconWidget extends ImplicitlyAnimatedWidget {
  const _IconWidget({
    required this.color,
    required this.isSelected,
  }) : super(duration: const Duration(milliseconds: 300));
  final Color color;
  final bool isSelected;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _IconWidgetState();
}

class _IconWidgetState extends AnimatedWidgetBaseState<_IconWidget> {
  Tween<double>? _rotationTween;

  @override
  Widget build(BuildContext context) {
    final rotation = math.pi * 4 * _rotationTween!.evaluate(animation);
    final scale = 1 + _rotationTween!.evaluate(animation) * 0.5;
    return Transform(
      transform: Matrix4.rotationZ(rotation).scaled(scale, scale),
      origin: const Offset(14, 14),
      child: Icon(
        widget.isSelected ? Icons.face_retouching_natural : Icons.face,
        color: widget.color,
        size: 28,
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _rotationTween = visitor(
      _rotationTween,
      widget.isSelected ? 1.0 : 0.0,
      (dynamic value) => Tween<double>(
        begin: value as double,
        end: widget.isSelected ? 1.0 : 0.0,
      ),
    ) as Tween<double>?;
  }
}
