import 'package:flutter/material.dart' hide AnimationStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/DashboardCenter/medical_dashboard_cubit.dart';
import 'package:graduation_project_frontend/cubit/DashboardCenter/medical_dashboard_state.dart';
import 'package:graduation_project_frontend/models/centerDashboard_model.dart';
import 'package:graduation_project_frontend/models/doctors_model.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';
import 'package:graduation_project_frontend/widgets/custom_toast.dart';
import 'package:graduation_project_frontend/widgets/mainScaffold.dart';
import 'package:graduation_project_frontend/widgets/modernStatistical.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MedicalDashboardScreen extends StatefulWidget {
  static final id = 'MedicalDashboardScreen';

  const MedicalDashboardScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MedicalDashboardScreenState createState() => _MedicalDashboardScreenState();
}

class _MedicalDashboardScreenState extends State<MedicalDashboardScreen> {
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 6)),
    end: DateTime.now(),
  );

  Future<void> _selectDateRange(BuildContext context) async {
    DateTime startDate = _selectedDateRange.start;
    DateTime endDate = _selectedDateRange.end;

    TextEditingController startController =
        TextEditingController(text: DateFormat('dd/MM/yyyy').format(startDate));
    TextEditingController endController =
        TextEditingController(text: DateFormat('dd/MM/yyyy').format(endDate));

    final DateTimeRange? picked = await showDialog<DateTimeRange>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select range'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: startController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Start Date'),
                onTap: () async {
                  DateTime? pickedStart = await showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (pickedStart != null) {
                    startDate = pickedStart;
                    startController.text =
                        DateFormat('dd/MM/yyyy').format(startDate);
                  }
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: endController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'End Date'),
                onTap: () async {
                  DateTime? pickedEnd = await showDatePicker(
                    context: context,
                    initialDate: endDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (pickedEnd != null) {
                    endDate = pickedEnd;
                    endController.text =
                        DateFormat('dd/MM/yyyy').format(endDate);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                
                  Navigator.pop(
                      context, DateTimeRange(start: startDate, end: endDate));
                
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
      // ignore: use_build_context_synchronously
 context.read<DashboardCubit>().loadDashboard(
     picked.start,
     picked.end,
  );
}    }
  

  @override
  void initState() {
    super.initState();
    // Delay the initialization slightly to ensure the provider is fully set up
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
 context.read<DashboardCubit>().loadDashboard(
         _selectedDateRange.start,
         _selectedDateRange.end,
      );      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: BlocConsumer<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardInitial) {
            return Center(child: CircularProgressIndicator(color: darkBlue));
          } else if (state is DashboardLoading) {
            return _buildLoadingView(state.loadProgress);
          } else if (state is DashboardLoaded) {
            return _buildDashboard(state.data);
          }
          return Container();
        },
        listener: (BuildContext context, state) {
          if (state is DashboardError) {
            showAdvancedNotification(context,
                message: state.message,
                type: NotificationType.error,
                style: AnimationStyle.card);
          }
        },
      ),
    );
  }

  Widget _buildLoadingView(double progress) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            radius: 80.0,
            lineWidth: 12.0,
            percent: progress,
            center: Text(
              '${(progress * 100).toInt()}%',
              style: customTextStyle(24, FontWeight.bold, darkBlue),
            ),
            progressColor: darkBabyBlue,
            backgroundColor: sky,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 200,
          ),
          SizedBox(height: 24),
          Text(
            'Loading dashboard...',
            style: customTextStyle(18, FontWeight.w400, darkBlue),
          ),
        ],
      ),
    );
  }

  Future<void> _loadDashboard() async {
    _buildLoadingView;
  }

  Widget _buildDashboard(Centerdashboard data) {
    // List<Doctor> doctorsList = context.watch<DoctorCubit>().doctors;

    return RefreshIndicator(
      onRefresh: _loadDashboard,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Overview',
              style: customTextStyle(22, FontWeight.w600, darkBlue),
            ),
            SizedBox(height: 16),

            // Modified stats cards - Now using the doctor dashboard style
            Row(
              children: [
                _buildStatCard(
                    'Radiologists',
                    data.totalRadiologists.toString(),
                    Icons.medical_services,
                    '${data.onlineRadiologists} online',
                    darkBlue),
                SizedBox(width: 20),
                _buildStatCard('Reports', 
                // data.monthlyRecords.toString(),
                (250??0).toString(),
                    Icons.description, 'This Month', Colors.indigo),
                SizedBox(width: 20),
                _buildStatCard('Today', 
                // data.todayRecords.toString(),
                (30??0).toString(),
                    Icons.today, 'Reports', darkBabyBlue),
                SizedBox(width: 20),
                _buildStatCard('This Week', 
                // data.weeklyRecords.toString(),
                (104??0).toString(),
                    Icons.calendar_today, 'Reports', darkBlue,),
              ],
            ),

            SizedBox(height: 24),

            if (data.onlineRadiologistsDetails.isNotEmpty) ...[
              Text(
                'Online Radiologists',
                style: customTextStyle(18, FontWeight.bold, darkBlue),
              ),
              SizedBox(height: 12),
              _buildOnlineRadiologistsList(data.onlineRadiologistsDetails),
              SizedBox(height: 24),
            ]else ...[
  Center(
    child: Container(
      padding: EdgeInsets.all(10),
      width: 250,
      height: 50,
      color: Colors.white,
      child: Text(
        'No doctors online',
        style: customTextStyle(20, FontWeight.w600, Colors.grey),
        textAlign: TextAlign.center,
      ),
              ),
  ),
  SizedBox(height: 24),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    _selectDateRange(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: darkBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.date_range, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          '${DateFormat('MMM d').format(_selectedDateRange.start)} - ${DateFormat('MMM d').format(_selectedDateRange.end)}',
                          style: customTextStyle(14, FontWeight.w300, Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Daily Reports Analytics',
              style: customTextStyle(18, FontWeight.bold, darkBlue),
            ),
            SizedBox(height: 12),
            Modernstatistical(dailyStats: data.dailyStats),
          ],
        ),
      ),
    );
  }

  // New card widget matching doctor dashboard style
  Widget _buildStatCard(
      String title, String value, IconData icon, String subtitle, Color color) {
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
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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
            SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineRadiologistsList(List<Doctor> radiologists) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: radiologists
            .map((radiologist) => _buildRadiologistCard(radiologist))
            .toList(),
      ),
    );
  }

  Widget _buildRadiologistCard(Doctor radiologist) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Profile Image
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(radiologist.imageUrl),
          ),
          SizedBox(width: 16),

          // Doctor Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  radiologist.fullName,
                  style: customTextStyle(16, FontWeight.w600, darkBlue),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  radiologist.specialization.join(', '),
                  style: customTextStyle(14, FontWeight.normal, grey),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Online',
                    style: customTextStyle(
                        12, FontWeight.w300, Colors.green.shade700),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: darkBabyBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.chat_bubble_outline, color: Colors.white),
              onPressed: () {
                // Navigate to chat with this radiologist
                _navigateToChat(radiologist);
              },
              tooltip: 'Chat with ${radiologist.firstName}',
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToChat(Doctor radiologist) {
    final mainState = context.findAncestorStateOfType<MainScaffoldState>();
    if (mainState != null) {
      mainState.setState(() {
        mainState.selectedIndex = 4;
        // mainState.selectedDoctor = radiologist;
      });
    }
  }
}
