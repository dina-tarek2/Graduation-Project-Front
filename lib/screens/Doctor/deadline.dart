import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/For_Doctor/records_list_cubit.dart';
import 'package:graduation_project_frontend/models/Doctor/records_list_model.dart';
import 'package:graduation_project_frontend/widgets/custom_button.dart';
import 'package:intl/intl.dart';


class DeadlineChecker {

  static const Duration _checkInterval = Duration(minutes: 1);
  static const int _alertThresholdMinutes = 60;
  static const String _dateFormat = 'yyyy-MM-dd HH:mm';
  

  static const MaterialColor _primaryDark = MaterialColor(
    0xFF081C34,
    <int, Color>{
      50: Color(0xFFE1E4E8),
      100: Color(0xFFB4BBC5),
      200: Color(0xFF828E9F),
      300: Color(0xFF506078),
      400: Color(0xFF2B3D5A),
      500: Color(0xFF081C34),
      600: Color(0xFF07192F),
      700: Color(0xFF061428),
      800: Color(0xFF051021),
      900: Color(0xFF030815),
    },
  );

  static const MaterialColor _primaryLight = MaterialColor(
    0xFF62B6CB,
    <int, Color>{
      50: Color(0xFFE8F4F7),
      100: Color(0xFFC6E3EB),
      200: Color(0xFFA0D1DE),
      300: Color(0xFF7ABFD0),
      400: Color(0xFF5EB1C6),
      500: Color(0xFF62B6CB),
      600: Color(0xFF5AA4B5),
      700: Color(0xFF50909C),
      800: Color(0xFF467C84),
      900: Color(0xFF345E64),
    },
  );
  
  // Private fields
  Timer? _deadlineTimer;
  final BuildContext _context;
  bool _isActive = false;
  final Set<String> _alreadyNotifiedRecords = <String>{};


  /// 
  /// [context] - The BuildContext for showing dialogs and accessing Cubits
  DeadlineChecker(this._context);


  void startDeadlineChecking() {
    if (_isActive) {
      debugPrint('DeadlineChecker: Already active, ignoring start request');
      return;
    }

    debugPrint('DeadlineChecker: Starting periodic deadline monitoring');
    
    _deadlineTimer = Timer.periodic(_checkInterval, _onTimerTick);
    _isActive = true;


    _performDeadlineCheck();
  }

  void stopDeadlineChecking() {
    if (!_isActive) return;

    debugPrint('DeadlineChecker: Stopping deadline monitoring');
    
    _deadlineTimer?.cancel();
    _deadlineTimer = null;
    _isActive = false;
    _alreadyNotifiedRecords.clear();
  }

  bool get isActive => _isActive;

  void _onTimerTick(Timer timer) {
    debugPrint('DeadlineChecker: Periodic check triggered at ${DateTime.now()}');
    _performDeadlineCheck();
  }


  void _performDeadlineCheck() {
    if (!_context.mounted) {
      debugPrint('DeadlineChecker: Context no longer mounted, stopping');
      stopDeadlineChecking();
      return;
    }

    try {
      final cubit = _context.read<RecordsListCubit>();
      final state = cubit.state;

      if (state is! RecordsListSuccess) {
        debugPrint('DeadlineChecker: Invalid state - ${state.runtimeType}');
        return;
      }

      final currentTime = DateTime.now().toUtc();
      final recordsToCheck = _getActiveRecords(state.records);
      
      debugPrint('DeadlineChecker: Checking ${recordsToCheck.length} active records');

      int alertCount = 0;
      for (final record in recordsToCheck) {
        if (_shouldShowAlert(record, currentTime)) {
          final minutesRemaining = _calculateMinutesRemaining(record, currentTime);
          _scheduleAlert(record, minutesRemaining);
          alertCount++;
        }
      }

      if (alertCount > 0) {
        debugPrint('DeadlineChecker: Scheduled $alertCount deadline alerts');
      }

    } catch (error, stackTrace) {
      debugPrint('DeadlineChecker: Error during check - $error');
      debugPrint('Stack trace: $stackTrace');
    }
  }


  List<RecordsListModel> _getActiveRecords(List<RecordsListModel> allRecords) {
    return allRecords.where((record) => 
      record.deadline != null && 
      !_isRecordCompleted(record)
    ).toList();
  }


  bool _isRecordCompleted(RecordsListModel record) {
    final status = record.status?.toLowerCase() ?? '';
    return status == 'completed' || status == 'cancelled';
  }


  bool _shouldShowAlert(RecordsListModel record, DateTime currentTime) {

    if (_alreadyNotifiedRecords.contains(record.id)) {
      return false;
    }

    final minutesRemaining = _calculateMinutesRemaining(record, currentTime);
    return minutesRemaining > 0 && minutesRemaining <= _alertThresholdMinutes;
  }

  /// Main method to check deadlines (kept for backward compatibility)
  void checkDeadlines() {
    _performDeadlineCheck();
  }

  /// Calculates minutes remaining until deadline
  int _calculateMinutesRemaining(RecordsListModel record, DateTime currentTime) {
    final deadline = record.deadline!.toUtc();
    return deadline.difference(currentTime).inMinutes;
  }


  void _scheduleAlert(RecordsListModel record, int minutesRemaining) {
    debugPrint('DeadlineChecker: Scheduling alert for record ${record.id}');
    

    _alreadyNotifiedRecords.add(record.id);
    
    Future.microtask(() => _showDeadlineAlert(record, minutesRemaining));
  }

  /// Shows a professional deadline alert dialog
  void _showDeadlineAlert(RecordsListModel record, int minutesRemaining) {
    if (!_context.mounted) return;

    final formattedDeadline = DateFormat(_dateFormat).format(record.deadline!);

    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (dialogContext) => _buildAlertDialog(
        dialogContext, 
        record, 
        formattedDeadline, 
        minutesRemaining
      ),
    );
  }

  /// Builds the alert dialog widget
  Widget _buildAlertDialog(
    BuildContext dialogContext,
    RecordsListModel record,
    String formattedDeadline,
    int minutesRemaining,
  ) {
    return BlocListener<RecordsListCubit, RecordsListState>(
      listener: (context, state) {
        if (state is ExtendedDeadlineSuccess) {
          // Handle successful deadline extension
          debugPrint('DeadlineChecker: Deadline extended successfully for record ${record.id}');
        }
      },
      child: WillPopScope(
        onWillPop: () async => false, // Prevent dismissal with back button
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: _buildAlertTitle(),
          content: _buildAlertContent(record, formattedDeadline, minutesRemaining),
          actions: _buildAlertActions(dialogContext, record),
        ),
      ),
    );
  }

  /// Builds the alert dialog title
  Widget _buildAlertTitle() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _primaryLight.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.schedule,
            color: _primaryDark.shade500,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Deadline Alert',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF081C34),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the alert dialog content
  Widget _buildAlertContent(
    RecordsListModel record,
    String formattedDeadline,
    int minutesRemaining,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _primaryLight.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _primaryLight.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                Icons.person,
                'Patient',
                record.patientName ?? 'Unknown',
                FontWeight.bold,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.access_time,
                'Deadline',
                formattedDeadline,
                FontWeight.normal,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.warning,
                'Time Remaining',
                '$minutesRemaining minutes',
                FontWeight.bold,
                color: Colors.red,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'This record is approaching its deadline. Would you like to extend it?',
          style: TextStyle(
            fontSize: 16,
            color: _primaryDark.shade500,
          ),
        ),
      ],
    );
  }

  /// Builds an information row with icon and text
  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    FontWeight fontWeight, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color ?? _primaryDark.shade500),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: _primaryDark.shade500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: fontWeight,
              color: color ?? _primaryDark.shade500,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the alert dialog action buttons
  List<Widget> _buildAlertActions(BuildContext dialogContext, RecordsListModel record) {
    return [
      CustomButton(
        text: "Dismiss",
        onTap: () => _onDismissAlert(dialogContext, record),
        width: 100,
        backgroundColor: Colors.grey,
      ),
      const SizedBox(width: 8),
      CustomButton(
        text: "Extend Deadline",
        onTap: () => _onExtendDeadline(dialogContext, record),
        width: 140,
        backgroundColor: Colors.blue,
      ),
    ];
  }

  /// Handles dismiss alert action
  void _onDismissAlert(BuildContext dialogContext, RecordsListModel record) {
    debugPrint('DeadlineChecker: User dismissed alert for record ${record.id}');
    Navigator.of(dialogContext).pop();
  }

  /// Handles extend deadline action
  void _onExtendDeadline(BuildContext dialogContext, RecordsListModel record) {
    debugPrint('DeadlineChecker: User requested deadline extension for record ${record.id}');
    
    try {
      _context.read<RecordsListCubit>().extendDeadline(record.id);
      Navigator.of(dialogContext).pop();
    } catch (error) {
      debugPrint('DeadlineChecker: Error extending deadline - $error');
      // Could show an error dialog here
    }
  }

  /// Disposes of the DeadlineChecker and cleans up resources
  void dispose() {
    stopDeadlineChecking();
    debugPrint('DeadlineChecker: Disposed');
  }
}