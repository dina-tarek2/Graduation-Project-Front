import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/models/centerDashboard_model.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';
import 'package:intl/intl.dart';

class Modernstatistical extends StatefulWidget {
  final Map<String, DailyReportStats> dailyStats;
  const Modernstatistical({required this.dailyStats});

  @override
  State<Modernstatistical> createState() => _ModernstatisticalState();
}

class _ModernstatisticalState extends State<Modernstatistical> {
  late List<Map<String, dynamic>> animatedData;

  @override
  void initState() {
    super.initState();

    // مبدئيًا القيم كلها 0 عشان نبدأ الأنيميشن منها
    animatedData = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ].map((day) {
      return {
        'day': day.substring(0, 3),
        'Pending': 0,
        'Reviewed': 0,
        'Available': 0,
      };
    }).toList();

    // بعد تأخير بسيط، نضيف القيم الحقيقية
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        animatedData = _prepareChartData(widget.dailyStats);
      });
    });
  }

  List<Map<String, dynamic>> _prepareChartData(Map<String, DailyReportStats> stats) {
    final List<Map<String, dynamic>> chartData = [];
    final List<String> daysOrder = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];

    for (var day in daysOrder) {
      if (stats.containsKey(day)) {
        final stat = stats[day]!;
        chartData.add({
          'day': day.substring(0, 3),
          'Pending': stat.pending,
          'Reviewed': stat.reviewed,
          'Available': stat.available,
        });
      } else {
        chartData.add({
          'day': day.substring(0, 3),
          'Pending': 0,
          'Reviewed': 0,
          'Available': 0,
        });
      }
    }
    return chartData;
  }

  Widget _buildGroupedBarChart(List<Map<String, dynamic>> data) {
    return BarChart(
      BarChartData(
        barGroups: generateGroupedBarGroups(data),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= data.length) return const SizedBox.shrink();
                return Text(
                  data[index]['day'],
                  style: customTextStyle(18, FontWeight.w600, Colors.black),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        barTouchData: BarTouchData(enabled: true),
        groupsSpace: 12,
        maxY: 5,
      ),
    );
  }

  List<BarChartGroupData> generateGroupedBarGroups(List<Map<String, dynamic>> data) {
    return List.generate(data.length, (index) {
      final item = data[index];

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (item['Pending'] as int).toDouble(),
            color: Colors.orange,
            width: 6,
            borderRadius: BorderRadius.circular(2),
          ),
          BarChartRodData(
            toY: (item['Reviewed'] as int).toDouble(),
            color: Colors.green,
            width: 6,
            borderRadius: BorderRadius.circular(2),
          ),
          BarChartRodData(
            toY: (item['Available'] as int).toDouble(),
            color: Colors.purple,
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
          style: customTextStyle(12, FontWeight.w300, grey),
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
      color: sky,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Legends
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reports Status by Day',
                  style: customTextStyle(16, FontWeight.w600, darkBlue),
                ),
                Row(
                  children: [
                    _buildChartLegendItem('Pending', Colors.orange),
                    SizedBox(width: 12),
                    _buildChartLegendItem('Reviewed', Colors.green),
                    SizedBox(width: 12),
                    _buildChartLegendItem('Available', Colors.purple),
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
