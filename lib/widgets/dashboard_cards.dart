import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/models/centerDashboard_model.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';

class DashboardCards extends StatelessWidget {
  final Centerdashboard data;

  const DashboardCards({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width to determine layout
    final screenWidth = MediaQuery.of(context).size.width;
    
    // For large screens: 4 cards in a row
    if (screenWidth > 1100) {
      return Row(
        children: [
          _buildStatCard('Radiologists', data.totalRadiologists.toString(), Icons.medical_services, '${data.onlineRadiologists} online', darkBlue),
          SizedBox(width: 20),
          _buildStatCard('Reports', data.monthlyRecords.toString(), Icons.description, 'This Month', Colors.blue),
          SizedBox(width: 20),
          _buildStatCard('Today', data.todayRecords.toString(), Icons.today, 'Reports', Colors.green),
          SizedBox(width: 20),
          _buildStatCard('This Week', data.weeklyRecords.toString(), Icons.calendar_today, 'Reports', Colors.orange),
        ],
      );
    } 
    // For medium screens: 2 rows with 2 cards each
    else if (screenWidth > 600) {
      return Column(
        children: [
          Row(
            children: [
              _buildStatCard('Radiologists', data.totalRadiologists.toString(), Icons.medical_services, '${data.onlineRadiologists} online', darkBlue),
              SizedBox(width: 20),
              _buildStatCard('Reports', data.monthlyRecords.toString(), Icons.description, 'This Month', Colors.blue),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              _buildStatCard('Today', data.todayRecords.toString(), Icons.today, 'Reports', Colors.green),
              SizedBox(width: 20),
              _buildStatCard('This Week', data.weeklyRecords.toString(), Icons.calendar_today, 'Reports', Colors.orange),
            ],
          ),
        ],
      );
    } 
    // For small screens: 4 cards stacked vertically
    else {
      return Column(
        children: [
          _buildStatCard('Radiologists', data.totalRadiologists.toString(), Icons.medical_services, '${data.onlineRadiologists} online', darkBlue, fullWidth: true),
          SizedBox(height: 15),
          _buildStatCard('Reports', data.monthlyRecords.toString(), Icons.description, 'This Month', Colors.blue, fullWidth: true),
          SizedBox(height: 15),
          _buildStatCard('Today', data.todayRecords.toString(), Icons.today, 'Reports', Colors.green, fullWidth: true),
          SizedBox(height: 15),
          _buildStatCard('This Week', data.weeklyRecords.toString(), Icons.calendar_today, 'Reports', Colors.orange, fullWidth: true),
        ],
      );
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon, String subtitle, Color color, {bool fullWidth = false}) {
    return fullWidth 
      ? Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: _buildCardContent(title, value, icon, subtitle, color),
        )
      : Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: _buildCardContent(title, value, icon, subtitle, color),
          ),
        );
  }

  Widget _buildCardContent(String title, String value, IconData icon, String subtitle, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 8),
            Text(
              title,
              style: customTextStyle(14, FontWeight.w500, color),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: customTextStyle(24, FontWeight.bold, color),
        ),
        SizedBox(height: 5),
        Text(
          subtitle,
          style: customTextStyle(13, FontWeight.w400, Colors.grey[600]!),
        ),
      ],
    );
  }
}