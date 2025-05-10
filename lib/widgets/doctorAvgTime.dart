import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DoctorAvgTimeWidget extends StatelessWidget {
  final int avgMinutes;
  static String id = 'DoctorAvgTimeWidget';

  const DoctorAvgTimeWidget({Key? key, required this.avgMinutes}) : super(key: key);

  Color getColor(int minutes) {
    if (minutes <= 20) return const Color(0xFF4CAF50); // Richer green
    if (minutes <= 30) return const Color(0xFFFF9800); // Deeper orange  
    return const Color(0xFFE53935); // Brighter red
  }

  String getMessage(int minutes) {
    if (minutes <= 20) return "Excellent! Very quick";
    if (minutes <= 30) return "Good, but could be faster";
    return "Quite long time";
  }

  @override
  Widget build(BuildContext context) {
    final color = getColor(avgMinutes);
    const double maxTime = 60.0; // Threshold for gauge percentage
    final double percentage = (avgMinutes / maxTime).clamp(0.0, 1.0) * 100;
    final message = getMessage(avgMinutes);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Average Diagnosis Time',
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$avgMinutes min",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 120,
                child: SizedBox(
                  width: double.infinity,
                  child: PieChart(
                    PieChartData(
                      startDegreeOffset: 180,
                      sectionsSpace: 0,
                      centerSpaceRadius: 0,
                      sections: [
                        PieChartSectionData(
                          value: percentage,
                          color: color,
                          radius: 16,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          value: 100 - percentage,
                          color: const Color(0xFFF5F5F5),
                          radius: 16,
                          showTitle: false,
                        ),
                      ],
                    ),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutQuart,
                  ),
                ),
              ),
              Column(
                children: [
                  Icon(
                    avgMinutes <= 20 
                      ? Icons.sentiment_very_satisfied
                      : avgMinutes <= 30 
                        ? Icons.sentiment_satisfied
                        : Icons.sentiment_dissatisfied,
                    color: color,
                    size: 32,
                  ),
                  const SizedBox(height: 55),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeIndicator(
                const Color(0xFF4CAF50),
                "< 20 min",
                "Excellent",
                avgMinutes <= 20,
              ),
              _buildDivider(),
              _buildTimeIndicator(
                const Color(0xFFFF9800),
                "20-30 min",
                "Good",
                avgMinutes > 20 && avgMinutes <= 30,
              ),
              _buildDivider(),
              _buildTimeIndicator(
                const Color(0xFFE53935),
                "> 30 min",
                "Long",
                avgMinutes > 30,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeIndicator(Color color, String time, String label, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isActive ? color : color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? Colors.black87 : Colors.black54,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: isActive ? color : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDivider() {
    return Container(
      height: 24,
      width: 1,
      color: Colors.grey.withOpacity(0.15),
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}