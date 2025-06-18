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
  _MedicalDashboardScreenState createState() => _MedicalDashboardScreenState();
}

class _MedicalDashboardScreenState extends State<MedicalDashboardScreen>
    with TickerProviderStateMixin {
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(Duration(days: 6)),
    end: DateTime.now(),
  );

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Modern color palette based on #081c34
  static const Color primaryDark = Color(0xFF081C34);
  static const Color primaryLight = Color(0xFF1A365D);
  static const Color accent = Color(0xFF3182CE);
  static const Color accentLight = Color(0xFF63B3ED);
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFED8936);
  static const Color error = Color(0xFFE53E3E);
  static const Color background = Color(0xFFF7FAFC);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    // Initialize dashboard data with date range parameters
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DashboardCubit>().loadDashboard(
          _selectedDateRange.start,
          _selectedDateRange.end,
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

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
          backgroundColor: cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Select Date Range',
            style: TextStyle(
              color: primaryDark,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDateField(
                controller: startController,
                label: 'Start Date',
                onTap: () async {
                  DateTime? pickedStart = await showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: primaryDark,
                            onPrimary: Colors.white,
                            surface: cardBackground,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedStart != null) {
                    startDate = pickedStart;
                    startController.text = DateFormat('dd/MM/yyyy').format(startDate);
                  }
                },
              ),
              SizedBox(height: 16),
              _buildDateField(
                controller: endController,
                label: 'End Date',
                onTap: () async {
                  DateTime? pickedEnd = await showDatePicker(
                    context: context,
                    initialDate: endDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: primaryDark,
                            onPrimary: Colors.white,
                            surface: cardBackground,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedEnd != null) {
                    endDate = pickedEnd;
                    endController.text = DateFormat('dd/MM/yyyy').format(endDate);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: textSecondary, fontWeight: FontWeight.w500),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, DateTimeRange(start: startDate, end: endDate));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Apply', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
      // Pass the new date range parameters to loadDashboard
      context.read<DashboardCubit>().loadDashboard(
        _selectedDateRange.start,
        _selectedDateRange.end,
      );
    }
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textSecondary),
        suffixIcon: Icon(Icons.calendar_today, color: primaryDark, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryDark, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: BlocConsumer<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardInitial) {
            return _buildLoadingState();
          } else if (state is DashboardLoading) {
            return _buildLoadingView(state.loadProgress);
          } else if (state is DashboardLoaded) {
            return AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildDashboard(state.data),
                  ),
                );
              },
            );
          }
          return Container();
        },
        listener: (BuildContext context, state) {
          if (state is DashboardError) {
            showAdvancedNotification(
              context,
              message: state.message,
              type: NotificationType.error,
              style: AnimationStyle.card,
            );
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primaryDark.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: primaryDark,
              strokeWidth: 3,
            ),
            SizedBox(height: 24),
            Text(
              'Initializing Dashboard...',
              style: TextStyle(
                color: textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView(double progress) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryDark.withOpacity(0.15),
              blurRadius: 30,
              offset: Offset(0, 15),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryDark),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: primaryDark,
                      ),
                    ),
                    Text(
                      'Loading',
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32),
            Text(
              'Preparing your dashboard...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please wait while we load your data',
              style: TextStyle(
                fontSize: 14,
                color: textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadDashboard() async {
    // Pass the current date range parameters to loadDashboard
    context.read<DashboardCubit>().loadDashboard(
      _selectedDateRange.start,
      _selectedDateRange.end,
    );
  }

  Widget _buildDashboard(Centerdashboard data) {
    return RefreshIndicator(
      onRefresh: _loadDashboard,
      color: primaryDark,
      backgroundColor: cardBackground,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 24),
            _buildStatsGrid(data),
            SizedBox(height: 32),
            if (data.onlineRadiologistsDetails.isNotEmpty) ...[
              _buildOnlineRadiologistsSection(data.onlineRadiologistsDetails),
              SizedBox(height: 32),
            ],
            _buildAnalyticsSection(data),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard Overview',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryDark,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Monitor your medical center\'s performance',
                style: TextStyle(
                  fontSize: 16,
                  color: textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: primaryDark.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            onPressed: _loadDashboard,
            icon: Icon(Icons.refresh_rounded, color: primaryDark),
            iconSize: 24,
            tooltip: 'Refresh Dashboard',
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(Centerdashboard data) {
    final stats = [
      {
        'title': 'Radiologists',
        'value': data.totalRadiologists.toString(),
        'subtitle': '${data.onlineRadiologists} online',
        'icon': Icons.medical_services_rounded,
        'color': primaryDark,
        'trend': '+2 this week',
      },
      {
        'title': 'Monthly Reports',
        'value': data.monthlyRecords.toString(),
        'subtitle': 'This month',
        'icon': Icons.description_rounded,
        'color': accent,
        'trend': '+15% vs last month',
      },
      {
        'title': 'Today\'s Reports',
        'value': data.todayRecords.toString(),
        'subtitle': 'Today',
        'icon': Icons.today_rounded,
        'color': success,
        'trend': '+3 since yesterday',
      },
      {
        'title': 'Weekly Reports',
        'value': data.weeklyRecords.toString(),
        'subtitle': 'This week',
        'icon': Icons.calendar_view_week_rounded,
        'color': warning,
        'trend': '+8% vs last week',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return _buildModernStatCard(
          title: stat['title'] as String,
          value: stat['value'] as String,
          subtitle: stat['subtitle'] as String,
          icon: stat['icon'] as IconData,
          color: stat['color'] as Color,
          trend: stat['trend'] as String,
        );
      },
    );
  }

  Widget _buildModernStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String trend,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Handle card tap
          },
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    Spacer(),
                    Icon(Icons.more_vert, color: textSecondary, size: 20),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.trending_up, color: success, size: 16),
                    SizedBox(width: 4),
                    Text(
                      trend,
                      style: TextStyle(
                        fontSize: 12,
                        color: success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineRadiologistsSection(List<Doctor> radiologists) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Online Radiologists',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryDark,
              ),
            ),
            SizedBox(width: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${radiologists.length} active',
                style: TextStyle(
                  color: success,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primaryDark.withOpacity(0.08),
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: radiologists
                .asMap()
                .entries
                .map((entry) => _buildModernRadiologistCard(
                      entry.value,
                      isLast: entry.key == radiologists.length - 1,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildModernRadiologistCard(Doctor radiologist, {bool isLast = false}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: isLast ? null : Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    radiologist.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: Icon(Icons.person, color: Colors.grey.shade400),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: success,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: cardBackground, width: 2),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  radiologist.fullName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  radiologist.specialization.join(', '),
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: success,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primaryDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _navigateToChat(radiologist),
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection(Centerdashboard data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Daily Reports Analytics',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryDark,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _selectDateRange(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: primaryDark.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryDark.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.date_range_rounded, color: primaryDark, size: 20),
                    SizedBox(width: 8),
                    Text(
                      '${DateFormat('MMM d').format(_selectedDateRange.start)} - ${DateFormat('MMM d').format(_selectedDateRange.end)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primaryDark.withOpacity(0.08),
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          child: Modernstatistical(dailyStats: data.dailyStats),
        ),
      ],
    );
  }

  void _navigateToChat(Doctor radiologist) {
    final mainState = context.findAncestorStateOfType<MainScaffoldState>();
    if (mainState != null) {
      mainState.setState(() {
        mainState.selectedIndex = 5;
      });
    }
  }
}