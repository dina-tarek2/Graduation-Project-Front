import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/HomeDoc/doctor_home_cubit.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/models/centerRecord.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';
import 'package:graduation_project_frontend/widgets/doctorAvgTime.dart';
import 'package:graduation_project_frontend/widgets/modern2.dart';
import 'package:intl/intl.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});
  static final id = 'DoctorDashboard';

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  DateTimeRange? selectedRange;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final doctorId = context.read<CenterCubit>().state;
    final now = DateTime.now();
    
    // Calculate current week range (Monday to Sunday)
    final currentWeekday = now.weekday; // Monday = 1, Sunday = 7
    final weekStart = now.subtract(Duration(days: currentWeekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    
    // Set default selected range to current week
    selectedRange = DateTimeRange(
      start: weekStart,
      end: weekEnd,
    );
    
    context.read<DoctorHomeCubit>().fetchDashboardData(
      doctorId: doctorId,
      startDate: weekStart.toIso8601String().split('T').first,
      endDate: weekEnd.toIso8601String().split('T').first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorHomeCubit, DoctorHomeState>(
      listener: (context, state) {
        if (state is DoctorHomeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                
                // Date Range Picker
                _buildDateRangeSelector(),
                
                const SizedBox(height: 12),
                
                // Loading or Content
                if (state is DoctorHomeLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (state is DoctorHomeLoaded)
                  ..._buildDashboardContent(state)
                else if (state is DoctorHomeError)
                  _buildErrorWidget(state.message)
                else
                  Center(
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Select date range to view data',
                              style: customTextStyle(16, FontWeight.w500, Colors.grey[600]!),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateRangeSelector() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Row(
              children: [
                // Current range display
                Expanded(
                  child: Container(
                    padding:  EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: sky.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: sky.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.date_range, color: darkBlue, size: 20),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected Range',
                              style: customTextStyle(12, FontWeight.w400, Colors.grey[600]!),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              selectedRange == null
                                  ? 'No range selected'
                                  : '${_formatDate(selectedRange!.start)} - ${_formatDate(selectedRange!.end)}',
                              style: customTextStyle(14, FontWeight.w600, darkBlue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                  Row(
              children: [
                // Text(
                //   'Quick Select: ',
                //   style: customTextStyle(14, FontWeight.w500, Colors.grey[600]!),
                // ),
                const SizedBox(width: 4),
                _buildQuickSelectButton('This Week', _selectCurrentWeek),
                const SizedBox(width: 4),
                _buildQuickSelectButton('This Month', _selectCurrentMonth),
                const SizedBox(width: 4),
                _buildQuickSelectButton('Last 7 Days', _selectLast7Days),
              ],
            ),
                const SizedBox(width: 16),
                
                // Custom date picker button
                ElevatedButton.icon(
                  onPressed: _selectDateRange,
                  icon: const Icon(Icons.edit_calendar),
                  label: const Text('Change Range'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                
              ],
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSelectButton(String label, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: darkBlue,
        side: BorderSide(color: sky),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  void _selectCurrentWeek() {
    final now = DateTime.now();
    final currentWeekday = now.weekday;
    final weekStart = now.subtract(Duration(days: currentWeekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    
    _updateDateRange(DateTimeRange(start: weekStart, end: weekEnd));
  }

  void _selectCurrentMonth() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    
    _updateDateRange(DateTimeRange(start: monthStart, end: monthEnd));
  }

  void _selectLast7Days() {
    final now = DateTime.now();
    final weekStart = now.subtract(const Duration(days: 6));
    
    _updateDateRange(DateTimeRange(start: weekStart, end: now));
  }

  void _updateDateRange(DateTimeRange range) {
    setState(() {
      selectedRange = range;
    });

    final doctorId = context.read<CenterCubit>().state;
    context.read<DoctorHomeCubit>().fetchDashboardData(
      doctorId: doctorId,
      startDate: range.start.toIso8601String().split('T').first,
      endDate: range.end.toIso8601String().split('T').first,
    );
  }

 Future<void> _selectDateRange() async {
  DateTime startDate = selectedRange?.start ?? DateTime.now();
  DateTime endDate = selectedRange?.end ?? DateTime.now();

  TextEditingController startController =
      TextEditingController(text: DateFormat('dd/MM/yyyy').format(startDate));
  TextEditingController endController =
      TextEditingController(text: DateFormat('dd/MM/yyyy').format(endDate));

  final DateTimeRange? picked = await showDialog<DateTimeRange>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.date_range, color: darkBlue),
                const SizedBox(width: 8),
                const Text('Select Date Range'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: startController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedStart = await showDatePicker(
                      context: context,
                      initialDate: startDate.isAfter(DateTime.now()) 
                          ? DateTime.now() 
                          : startDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (pickedStart != null) {
                      setDialogState(() {
                        startDate = pickedStart;
                        startController.text =
                            DateFormat('dd/MM/yyyy').format(startDate);
                        
                        // Ensure end date is not before start date
                        if (endDate.isBefore(startDate)) {
                          endDate = startDate;
                          endController.text =
                              DateFormat('dd/MM/yyyy').format(endDate);
                        }
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: endController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'End Date',
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedEnd = await showDatePicker(
                      context: context,
                      initialDate: endDate.isAfter(DateTime.now()) 
                          ? DateTime.now() 
                          : endDate,
                      firstDate: startDate,
                      lastDate: DateTime.now(),
                    );
                    if (pickedEnd != null) {
                      setDialogState(() {
                        endDate = pickedEnd;
                        endController.text =
                            DateFormat('dd/MM/yyyy').format(endDate);
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (endDate.isBefore(startDate)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('End date must be after start date'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  Navigator.pop(
                    context,
                    DateTimeRange(start: startDate, end: endDate),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Apply'),
              ),
            ],
          );
        },
      );
    },
  );

  if (picked != null) {
    _updateDateRange(picked);
  }
}
  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  List<Widget> _buildDashboardContent(DoctorHomeLoaded state) {
    return [
     
      _buildStatisticsRow(state.stats, state.recordCount),
      
      const SizedBox(height: 32),
      
      // Main Content Grid
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column - Center Records
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Centers Overview',
                  style: customTextStyle(20, FontWeight.bold, darkBlue),
                ),
                const SizedBox(height: 16),
                _buildCenterRecordsList(state.centerRecord),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
           Expanded(
            flex: 2,
            child: Column(
              children: [
              _buildStatusChart(state.stats),
              ],
            ),
            ),
         
        ],
      ),
      
      const SizedBox(height: 12),
      Row(
        children : [
          
          
           Expanded(
            flex: 3,
            child: Column(
              children: [
      Modernstatistical2(weeklyStatusCounts: state.weeklyStatusCounts),
                const SizedBox(height: 12),
              ],
            ),
            ),
              Expanded(
            flex: 2,
            child:
                DoctorAvgTimeWidget(avgMinutes: state.avgTime),
          ),
        ]
      )

      
      
    ];
  }
  
  Widget _buildCenterRecordsList(List<CenterRecord> centerRecord) {
    if (centerRecord.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No records available',
                style: customTextStyle(16, FontWeight.w500, Colors.grey[600]!),
              ),
              const SizedBox(height: 8),
              Text(
                'Records will appear here once you start processing reports',
                style: customTextStyle(14, FontWeight.w400, Colors.grey[500]!),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.business, color: darkBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Medical Centers',
                  style: customTextStyle(18, FontWeight.bold, darkBlue),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: centerRecord.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final record = centerRecord[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.centerName,
                        style: customTextStyle(16, FontWeight.bold, darkBlue),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildStatusIndicator(
                            'Completed',
                            record.Completed.toString(),
                            Colors.green,
                            Icons.check_circle,
                          ),
                          const SizedBox(width: 24),
                          _buildStatusIndicator(
                            'Pending',
                            record.notCompleted.toString(),
                            Colors.orange,
                            Icons.pending,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String label, String value, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: customTextStyle(16, FontWeight.bold, color),
            ),
            Text(
              label,
              style: customTextStyle(12, FontWeight.w400, Colors.grey[600]!),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticsRow(Map<String, int> stats, int recordCount) {
    return Row(
      children: [
        _buildStatCard(
          'Total Records', 
          recordCount.toString(), 
          Colors.indigo,
          Icons.description,
          'All time records'
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'In Diagnosis', 
          (stats['Diagnose'] ?? 0).toString(), 
          Colors.deepOrange,
          Icons.pending,
          'Currently processing'
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Completed', 
          (stats['Completed'] ?? 0).toString(), 
          Colors.green,
          Icons.check_circle,
          'Successfully finished'
        ),
        const SizedBox(width: 16),
        _buildStatCard(
          'Ready', 
          (stats['Ready'] ?? 0).toString(), 
          Colors.blue,
          Icons.file_present,
          'Awaiting review'
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon, String subtitle) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  Text(
                    value,
                    style: customTextStyle(24, FontWeight.bold, color),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: customTextStyle(16, FontWeight.w600, darkBlue),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: customTextStyle(12, FontWeight.w400, Colors.grey[600]!),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChart(Map<String, int> stats) {
    final total = (stats['Ready'] ?? 0) + (stats['Diagnose'] ?? 0) + (stats['Completed'] ?? 0);
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart, color: darkBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Status Distribution',
                  style: customTextStyle(18, FontWeight.bold, darkBlue),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (total > 0) ...[
              _buildProgressBar('Ready', stats['Ready'] ?? 0, total, Colors.blue),
              const SizedBox(height: 16),
              _buildProgressBar('In Diagnosis', stats['Diagnose'] ?? 0, total, Colors.deepOrange),
              const SizedBox(height: 16),
              _buildProgressBar('Completed', stats['Completed'] ?? 0, total, Colors.green),
            ] else
              Container(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Icon(
                      Icons.pie_chart_outline,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No data to display',
                      style: customTextStyle(14, FontWeight.w500, Colors.grey[600]!),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String label, int value, int total, Color color) {
    final percentage = total > 0 ? (value / total * 100).round() : 0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label, 
              style: customTextStyle(14, FontWeight.w500, darkBlue),
            ),
            Text(
              '$value ($percentage%)', 
              style: customTextStyle(14, FontWeight.bold, color),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: total > 0 ? value / total : 0,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildErrorWidget(String message) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline, 
              size: 64, 
              color: Colors.red[400],
            ),
            const SizedBox(height: 20),
            Text(
              'Error Loading Data',
              style: customTextStyle(18, FontWeight.bold, Colors.red[700]!),
            ),
            const SizedBox(height: 10),
            Text(
              message, 
              textAlign: TextAlign.center,
              style: customTextStyle(14, FontWeight.w400, Colors.grey[600]!),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadInitialData,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}