import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/widgets/doctorAvgTime.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});
  static final id = 'DoctorDashboard';
  
  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  
 
  // Statistics
  final Map<String, int> _stats = {
    'New Cases': 5,
    'Under Review': 3,
    'Responded': 12,
    'Rejected': 1
  };


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Here would be your sidebar/navigation drawer
          // Assuming it's handled elsewhere in your app structure
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick stats cards
                  const Text(
                    'Quick Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _buildStatCard('New Cases', _stats['New Cases'].toString(), Colors.blue),
                      const SizedBox(width: 20),
                      _buildStatCard('Under Review', _stats['Under Review'].toString(), Colors.orange),
                      const SizedBox(width: 20),
                      _buildStatCard('Responded', _stats['Responded'].toString(), Colors.green),
                      const SizedBox(width: 20),
                      _buildStatCard('Rejected', _stats['Rejected'].toString(), Colors.red),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                 
                  
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                         
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Average Time Widget
                      Expanded(
                        flex: 2,
                        child: DoctorAvgTimeWidget(avgMinutes: 25),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          // ignore: deprecated_member_use
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}