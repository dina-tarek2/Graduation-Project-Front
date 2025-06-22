import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:graduation_project_frontend/models/Doctor/records_list_model.dart';
import 'package:graduation_project_frontend/cubit/For_Doctor/records_list_cubit.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/screens/viewer.dart';

class NewDicomPage extends StatefulWidget {
  static final id = "NewDicomPage";

  const NewDicomPage({super.key});

  @override
  _NewDicomPageState createState() => _NewDicomPageState();
}

class _NewDicomPageState extends State<NewDicomPage> {
  @override
  void initState() {
    super.initState();
    final userId = context.read<CenterCubit>().state;
    context.read<RecordsListCubit>().fetchRecords(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RecordsListCubit, RecordsListState>(
        builder: (context, state) {
          if (state is RecordsListLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is RecordsListFailure) {
            return Center(child: Text("Error: ${state.error}"));
          } else if (state is RecordsListSuccess) {
            final readyRecords = state.records
                .where((record) => record.status == "Ready")
                .toList();
            readyRecords.sort((a, b) {
              if (a.isEmergency != b.isEmergency) {
                return a.isEmergency ? -1 : 1; // الطارئة الأول
              }
              return a.deadline.compareTo(b.deadline); // بعد كده أقرب Deadline
            });
            if (readyRecords.isEmpty) {
              return Center(child: Text("No Ready Records Available"));
            }

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: readyRecords.length,
              itemBuilder: (context, index) {
                return _buildRecordCard(readyRecords[index]);
              },
            );
          } else {
            return Center(child: Text("Not have New Reports"));
          }
        },
      ),
    );
  }

  Widget _buildRecordCard(RecordsListModel record) {
    final now = DateTime.now();
    final difference = record.deadline.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);

    final isEmergency = record.isEmergency;
    final cardColor = isEmergency ? Colors.red.shade50 : Colors.white;
    final borderColor =
        isEmergency ? Colors.red.shade300 : Colors.grey.shade300;

    return Card(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: 1.5),
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  record.centerName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (isEmergency)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red, size: 18),
                        SizedBox(width: 4),
                        Text("Emergency",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
              ],
            ),

            SizedBox(height: 8),
            Text(
              "Patient: ${record.patientName}",
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),

            SizedBox(height: 12),
            // Deadline countdown
            Row(
              children: [
                Icon(Icons.timer_outlined,
                    color: difference.isNegative ? Colors.red : Colors.grey),
                SizedBox(width: 6),
                Text(
                  difference.isNegative
                      ? "Overdue by ${hours.abs()}h ${minutes.abs()}m"
                      : "Due in: ${hours}h ${minutes}m",
                  style: TextStyle(
                    color: difference.isNegative ? Colors.red : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Buttons Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green.shade600,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      // Approve API
                      context.read<RecordsListCubit>().approveRecord(record.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check, size: 20),
                        SizedBox(width: 6),
                        Text("Approve", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red.shade500,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      // Cancel API here
                      context.read<RecordsListCubit>().cancelRecord(record.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close, size: 20),
                        SizedBox(width: 6),
                        Text("Cancel", style: TextStyle(fontSize: 16)),
                      ],
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
}
