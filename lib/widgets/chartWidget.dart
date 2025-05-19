import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:graduation_project_frontend/models/centerDashboard_model.dart';

class ChartPage extends StatefulWidget {
  final List<double> values;
  final List<String> labels;
final Map<String, DailyReportStats> dailyStats;
  const ChartPage( {Key? key, required this.values,
   required this.labels,required this.dailyStats}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showGrid = true;
  bool _showTooltips = true;
  double _zoomFactor = 1.0;
  late double _maxY;
@override
void initState() {
  super.initState();
  _tabController = TabController(length: 3, vsync: this);
  _tabController.addListener(() {
  if (!_tabController.indexIsChanging) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
});

  _calculateMaxY();
}


  void _calculateMaxY() {
    double maxValue = widget.values.isEmpty ? 1 : widget.values.reduce(max);
    _maxY = maxValue == 0 ? 5 : maxValue * 1.2;
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: _maxY,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(widget.values.length, (index) => FlSpot(index.toDouble(), widget.values[index])),
            isCurved: true,
            barWidth: 3,
            color: Colors.blue,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true),
          ),
        ],
        gridData: FlGridData(show: _showGrid),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                if (value.toInt() >= 0 && value.toInt() < widget.labels.length) {
                  return Text(widget.labels[value.toInt()], style: TextStyle(fontSize: 10));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final interval = (_maxY / 5).ceilToDouble();
                if (value % interval == 0) {
                  return Text(value.toInt().toString(), style: TextStyle(fontSize: 10));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(enabled: _showTooltips),
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        minY: 0,
        maxY: _maxY,
        barGroups: List.generate(
          widget.values.length,
          (index) => BarChartGroupData(x: index, barRods: [
            BarChartRodData(toY: widget.values[index], width: 16, color: Colors.orange),
          ]),
        ),
        gridData: FlGridData(show: _showGrid),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                if (value.toInt() >= 0 && value.toInt() < widget.labels.length) {
                  return Text(widget.labels[value.toInt()], style: TextStyle(fontSize: 10));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final interval = (_maxY / 5).ceilToDouble();
                if (value % interval == 0) {
                  return Text(value.toInt().toString(), style: TextStyle(fontSize: 10));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        barTouchData: BarTouchData(enabled: _showTooltips),
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: List.generate(widget.values.length, (index) {
          final value = widget.values[index];
          final percentage = value / widget.values.reduce((a, b) => a + b) * 100;
          return PieChartSectionData(
            value: value,
            title: '${percentage.toStringAsFixed(1)}%',
            color: Colors.primaries[index % Colors.primaries.length],
            radius: 100,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
          );
        }),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildChart() {
    switch (_tabController.index) {
      case 0:
        return _buildLineChart();
      case 1:
        return _buildBarChart();
      case 2:
        return _buildPieChart();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charts'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Line'),
            Tab(text: 'Bar'),
            Tab(text: 'Pie'),
          ],
          // onTap: (_) => setState(() {}),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: Padding(padding: const EdgeInsets.all(8.0), child: _buildChart())),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Show Grid'),
                  value: _showGrid,
                  onChanged: (val) => setState(() => _showGrid = val),
                ),
                SwitchListTile(
                  title: const Text('Show Tooltips'),
                  value: _showTooltips,
                  onChanged: (val) => setState(() => _showTooltips = val),
                ),
                Row(
                  children: [
                    const Text('Zoom:'),
                    Expanded(
                      child: Slider(
                        value: _zoomFactor,
                        min: 0.5,
                        max: 2.0,
                        divisions: 15,
                        label: _zoomFactor.toStringAsFixed(1),
                        onChanged: (val) => setState(() => _zoomFactor = val),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
