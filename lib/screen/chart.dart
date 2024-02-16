import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vote_app/api/api_base/api_response.dart';
import 'package:vote_app/api/api_request.dart';
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
  final dataList = [
    const _BarData(Colors.red, 18),
    const _BarData(Colors.orange, 8),
    const _BarData(Colors.yellow, 15),
    const _BarData(Colors.green, 5),
    const _BarData(Colors.pink, 2.5),
  ];
  int role = 1;
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

  // Danh sách màu sắc tương ứng với mỗi phần
  List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.pink,
  ];

  // Danh sách chú thích cho các cảm xúc
  final List<String> emotions = [
    'Rất Tệ',
    'Tệ',
    'Bình thường',
    'Tốt',
    'Hoàn hảo',
  ];
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
    if (res.code == 200) {
      List<dynamic> data = res.data['data'];

      for (var item in data) {
        double count = (item['count'] as int).toDouble();
        percentages.add(count);
      }
    }
  }

  int touchedGroupIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(47, 179, 178, 1),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
              onPressed: () async {
                print(timeEnd + timeCreate);
                print(_selectedOption);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                role = prefs.getInt('role')!;
                // exportToExcel(timeCreate, timeEnd, _selectedOption!);
                exportToChart(timeCreate, timeEnd, _selectedOption!);
              },
              child: Text("Xem thông tin với excel"),
            ),
            role == 1
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
                            title: emotions[index],
                          ),
                        ),
                      ),
                    ),
                  )
                : Padding(
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
                                  color:
                                      const Color.fromARGB(137, 235, 119, 119)),
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
                                      isSelected: touchedGroupIndex == index,
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
                              color: const Color.fromARGB(137, 235, 119, 119),
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
                          maxY: 20,
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
                                  touchedGroupIndex =
                                      response.spot!.touchedBarGroupIndex;
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
            SizedBox(height: 20),
            // Danh sách chú thích
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                emotions.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyListViewScreen(
                                index: index,
                                timeCreate: timeCreate,
                                timeEnd: timeEnd,
                                selectedOption: _selectedOption.toString(),
                              )),
                    ),
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
            ),
          ],
        ),
      ),
    );
  }

  double getMaxValue() {
    double max = 0;
    for (double value in percentages) {
      if (value > max) {
        max = value;
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
