import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/constants/colors.dart';

import 'package:graduation_project_frontend/widgets/customTextStyle.dart';

class Modernstatistical2 extends StatefulWidget {
  final Map<String, dynamic> weeklyStatusCounts;

  const Modernstatistical2({required this.weeklyStatusCounts});

  @override
  State<Modernstatistical2> createState() => _ModernstatisticalState();
}

class _ModernstatisticalState extends State<Modernstatistical2> {
  late List<Map<String, dynamic>> animatedData;

  @override
  void initState() {
    super.initState();
    animatedData = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
      return {
        'day': day,
        'Diagnose': 0,
        'Completed': 0,
        'Ready': 0,
      };
    }).toList();

    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          animatedData =
              _prepareChartDataFromWeeklyObject(widget.weeklyStatusCounts);
        });
   

      }
    });
  }

  List<Map<String, dynamic>> _prepareChartDataFromWeeklyObject(
      Map<String, dynamic> weeklyData) {
    final data = weeklyData['data'] ?? weeklyData;

    final List<String> dayOrder = [
      'Sat',
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri'
    ];
    final Map<String, String> dayMapping = {
      'Mon': 'Monday',
      'Tue': 'Tuesday',
      'Wed': 'Wednesday',
      'Thu': 'Thursday',
      'Fri': 'Friday',
      'Sat': 'Saturday',
      'Sun': 'Sunday',
    };

    return dayOrder.map((shortDay) {
      final fullDay = dayMapping[shortDay]!;
      final dayData = data[fullDay] as Map<String, dynamic>? ?? {};
      return {
        'day': shortDay,
        'Diagnose': dayData['Diagnose'] ?? 0,
        'Completed': dayData['Completed'] ?? 0,
        'Ready': dayData['Ready'] ?? 0,
      };
    }).toList();
  }

  Widget _buildGroupedBarChart(List<Map<String, dynamic>> data) {
    int maxValue = 0;
    for (var item in data) {
      int dayMax = [
        item['Diagnose'] as int,
        item['Completed'] as int,
        item['Ready'] as int
      ].reduce((a, b) => a > b ? a : b);
      if (dayMax > maxValue) maxValue = dayMax;
    }

    double chartMaxY = (maxValue < 10) ? 10 : (maxValue * 1.2);

    return BarChart(
      BarChartData(
        barGroups: generateGroupedBarGroups(data),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= data.length)
                  return const SizedBox.shrink();
                return Text(
                  data[index]['day'],
                  style: customTextStyle(16, FontWeight.w500, Colors.black),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: customTextStyle(14, FontWeight.w400, Colors.black),
                );
              },
              reservedSize: 40,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(color: Colors.grey.shade200, width: 1),
            bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String status = ['Diagnose', 'Completed', 'Ready'][rodIndex];
              return BarTooltipItem(
                '$status\n${rod.toY.round()}',
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        groupsSpace: 12,
        minY: 0,
        maxY: chartMaxY,
      ),
    );
  }

  List<BarChartGroupData> generateGroupedBarGroups(
      List<Map<String, dynamic>> data) {
    return List.generate(data.length, (index) {
      final item = data[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (item['Diagnose'] as int).toDouble(),
            color: Colors.orange,
            width: 6,
            borderRadius: BorderRadius.circular(2),
          ),
          BarChartRodData(
            toY: (item['Completed'] as int).toDouble(),
            color: Colors.green,
            width: 6,
            borderRadius: BorderRadius.circular(2),
          ),
          BarChartRodData(
            toY: (item['Ready'] as int).toDouble(),
            color: sky,
            width: 6,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
        barsSpace: 4,
      );
    });
  }

  Widget _buildChartLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: customTextStyle(
              12, FontWeight.w300, Colors.grey[600] ?? Colors.grey),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reports Status by Day',
                  style: customTextStyle(16, FontWeight.w600, darkBlue),
                ),
                Row(
                  children: [
                    _buildChartLegendItem('Diagnose', Colors.orange),
                    SizedBox(width: 12),
                    _buildChartLegendItem('Completed', Colors.green),
                    SizedBox(width: 12),
                    _buildChartLegendItem('Ready', sky),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: _buildGroupedBarChart(animatedData),
            ),
          ],
        ),
      ),
    );
  }
}
