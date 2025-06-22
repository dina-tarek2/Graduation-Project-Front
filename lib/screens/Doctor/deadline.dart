import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/For_Doctor/records_list_cubit.dart';
import 'package:graduation_project_frontend/models/Doctor/records_list_model.dart';
import 'package:graduation_project_frontend/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class DeadlineChecker {
  Timer? _deadlineTimer;
  final BuildContext context;
  bool _isActive = false; // إضافة متغير للتحقق من حالة التشغيل

  // Constructor to initialize with context
  DeadlineChecker(this.context);

  // Start periodic checking
  void startDeadlineChecking() {
    if (_isActive) return;

    print(
        "Starting deadline checking..."); // إضافة رسالة تصحيح للتأكد من أن المؤقت بدأ

    // Check every minute (60 seconds)
    _deadlineTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      print("Timer triggered at ${DateTime.now()}"); // رسالة تصحيح
      checkDeadlines();
    });

    _isActive = true;

    // Also check immediately when started
    print("Running initial deadline check");
    checkDeadlines();
  }

  // Stop checking when not needed
  void stopDeadlineChecking() {
    print("Stopping deadline checks");
    _deadlineTimer?.cancel();
    _deadlineTimer = null;
    _isActive = false;
  }

  // Main function to check deadlines
  void checkDeadlines() {
    print("Checking deadlines...");

    if (!context.mounted) {
      print("Context is not mounted anymore");
      stopDeadlineChecking();
      return;
    }

    try {
      final cubit = context.read<RecordsListCubit>();
      final state = cubit.state;

      if (state is RecordsListSuccess) {
        // استخدم DateTime.now() مع تحديد نفس منطقة التوقيت المستخدمة في قاعدة البيانات
        final DateTime now = DateTime.now()
            .toUtc(); // استخدم UTC إذا كانت قاعدة البيانات تستخدم UTC

        print("Current UTC time: $now");
        print("Total records to check: ${state.records.length}");

        int count = 0;

        for (RecordsListModel record in state.records) {
          if (record.deadline != null &&
              record.status != "Completed" &&
              record.status != "Cancled") {
            final DateTime deadlineInCorrectTimeZone = record.deadline!.toUtc();

            final int differenceInMinutes =
                deadlineInCorrectTimeZone.difference(now).inMinutes;

            print("Record ID: ${record.id}, Patient: ${record.patientName}");
            print(
                "Deadline: ${record.deadline}, Minutes remaining: $differenceInMinutes");

            if (differenceInMinutes > 0 && differenceInMinutes <= 60) {
              print(
                  "⚠️ ALERT NEEDED! Record approaching deadline: ${record.id}");
              count++;
              Future.microtask(() {
                _showDeadlineAlert(record, differenceInMinutes);
              });
            }
          }
        }

        print("Found $count records requiring alerts");
      } else {
        print("State is not UploadedDicomsSuccess: ${state.runtimeType}");
      }
    } catch (e) {
      print("Error in checkDeadlines: $e");
    }
  }

  // Show non-dismissible alert dialog
  void _showDeadlineAlert(RecordsListModel record, int minutesRemaining) {
    if (!context.mounted) return;

    // Format the deadline time for display
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final formattedDeadline = dateFormat.format(record.deadline!);

    showDialog(
      context: context,
      barrierDismissible: false, // Cannot dismiss by tapping outside
      builder: (BuildContext dialogContext) {
        return BlocListener<RecordsListCubit, RecordsListState>(
          listener: (context, state) {
            if (state is ExtendedDeadlineSuccess) return;
          },
          child: WillPopScope(
            // Prevent closing with back button
            onWillPop: () async => false,
            child: AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.alarm, color: Colors.red),
                  const SizedBox(width: 10),
                  const Text("Warning: The deadline is about to end!"),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "patient name: ${record.patientName}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("deadline: $formattedDeadline"),
                  const SizedBox(height: 8),
                  Text(
                    " remaining time: $minutesRemaining minutes",
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text("Do you want to extend the deadline?"),
                ],
              ),
              actions: [
                CustomButton(
                  text: "Cancel",
                  onTap: () {
                    // We might want to log this action but not dismiss
                    // For now, just close the dialog
                    Navigator.of(dialogContext).pop();
                  },
                  width: 100,
                  backgroundColor: Colors.grey,
                ),
                CustomButton(
                  text: "Extend deadline",
                  onTap: () {
                    context.read<RecordsListCubit>().extendDeadline(record.id);
                    Navigator.of(dialogContext).pop();
                  },
                  width: 120,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to extend the deadline
  // void _extendDeadline(RecordsListModel record) {
  //   // Calculate new deadline (adding 2 hours to current deadline)
  //   final DateTime newDeadline = record.deadline!.add(const Duration(hours: 2));

  //   // Format for display and API
  //   final DateFormat apiFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  //   final String formattedDeadline = apiFormat.format(newDeadline);

  //   // Call API to update deadline
  //   // context.read<UploadedDicomsCubit>().updateDicomDeadline(
  //   //   context,
  //   //   record.id,
  //   //   {"deadline": formattedDeadline},
  //   // );
  //   print(
  //       "Should extend deadline for record ${record.id} to $formattedDeadline");
  // }
}
