import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';
import 'package:graduation_project_frontend/widgets/doctorAvgTime.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({Key? key}) : super(key: key);
  static final id = 'DoctorDashboard';
  
  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Sample data for cases
  final List<Map<String, dynamic>> _allCases = [
    {'id': 'C1023', 'patientName': 'Ahmed Mahmoud', 'status': 'New', 'date': '2025-05-07', 'priority': 'Normal'},
    {'id': 'C1022', 'patientName': 'Sarah Ali', 'status': 'Under Review', 'date': '2025-05-06', 'priority': 'Urgent'},
    {'id': 'C1021', 'patientName': 'Mohammed Ahmed', 'status': 'New', 'date': '2025-05-06', 'priority': 'Normal'},
    {'id': 'C1020', 'patientName': 'Fatima Hassan', 'status': 'New', 'date': '2025-05-05', 'priority': 'Urgent'},
    {'id': 'C1019', 'patientName': 'Khalid Abdullah', 'status': 'Responded', 'date': '2025-05-04', 'priority': 'Normal'}
  ];
  
  // Statistics
  final Map<String, int> _stats = {
    'New Cases': 5,
    'Under Review': 3,
    'Responded': 12,
    'Rejected': 1
  };

  // Today's notifications
  final List<Map<String, String>> _notifications = [
    {'title': 'Urgent Case', 'description': 'Case C1022 needs immediate attention'},
    {'title': 'Reminder', 'description': '3 cases pending for more than 48 hours'}
  ];

  List<Map<String, dynamic>> get _filteredCases {
    if (_searchQuery.isEmpty) {
      return _allCases.take(5).toList(); // Display only the latest 5 cases
    }
    return _allCases
        .where((c) => 
            c['id'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c['patientName'].toString().toLowerCase().contains(_searchQuery.toLowerCase()))
        .take(5)
        .toList();
  }

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
                  
                  // Latest cases and search
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Cases',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search cases or patients...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  
                  // Cases table
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: const [
                              Expanded(flex: 1, child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('Patient Name', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('Priority', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 1, child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredCases.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final caseItem = _filteredCases[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              child: Row(
                                children: [
                                  Expanded(flex: 1, child: Text(caseItem['id'])),
                                  Expanded(flex: 2, child: Text(caseItem['patientName'])),
                                  Expanded(
                                    flex: 2, 
                                    child: _buildStatusChip(caseItem['status'])
                                  ),
                                  Expanded(flex: 2, child: Text(caseItem['date'])),
                                  Expanded(
                                    flex: 2,
                                    child: _buildPriorityBadge(caseItem['priority'])
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.visibility, size: 16),
                                      label: const Text('View'),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // View all button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('View All Cases'),
                    ),
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
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Today\'s Reminders',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _notifications.length,
                                separatorBuilder: (context, index) => const Divider(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: const CircleAvatar(
                                      backgroundColor: Color(0xFFE3F2FD),
                                      child: Icon(Icons.notifications_none, color: Colors.blue),
                                    ),
                                    title: Text(_notifications[index]['title']!),
                                    subtitle: Text(_notifications[index]['description']!),
                                    contentPadding: EdgeInsets.zero,
                                  );
                                },
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
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
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

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;
    
    switch (status) {
      case 'New':
        bgColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        break;
      case 'Under Review':
        bgColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        break;
      case 'Responded':
        bgColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        break;
      case 'Rejected':
        bgColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        break;
      default:
        bgColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color color = priority == 'Urgent' ? Colors.red : Colors.green;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        priority,
        style: customTextStyle(15, FontWeight.w500, color)
      ),
    );
  }
}