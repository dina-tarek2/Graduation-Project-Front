import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/models/doctors_model.dart';
import 'package:graduation_project_frontend/constants/colors.dart';

class DoctorReportsChart extends StatelessWidget {
  final List<Doctor> doctors;
  const DoctorReportsChart({super.key, required this.doctors});
static final id ='DoctorReportsChart';
  @override
  Widget build(BuildContext context) {
    final chartData = doctors.map((doctor) {
      return {
        'name': doctor.fullName,
        'count': doctor.totalReports,
      };
    }).toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: sky,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reports per Doctor',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 5,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= chartData.length) {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              (chartData[index]['name']as String).split(' ')[0],
                              style: const TextStyle(
                                fontSize: 10,
                                color: blue,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(chartData.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: (chartData[index]['count'] as int).toDouble(),
                          color: darkBabyBlue,
                          width: 16,
                          borderRadius: BorderRadius.circular(6),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 5,
                            color: sky,
                          ),
                        )
                      ],
                    );
                  }),
                  gridData: FlGridData(show: false),
                  groupsSpace: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // double _getMaxY(List<Map<String, dynamic>> data) {
  //   final max = data.map((e) => e['count'] as int).fold(0, (prev, curr) => curr > prev ? curr : prev);
  //   return (max + 5).toDouble();
  // }
}
