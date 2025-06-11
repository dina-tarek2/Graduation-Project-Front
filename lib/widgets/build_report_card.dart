 import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/models/reports_model.dart';
import 'package:intl/intl.dart';
Widget buildReportCard(Report report) {
  final dateFormat = DateFormat('MMM dd, yyyy HH:mm');
  return Card(
    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Patient: ${report.patientName ?? "Loading..."}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: report.status == 'Available' ? Colors.blue.shade100 : 
                   report.status == 'Pending' ? Colors.orange.shade100 :
                    report.status == 'Completed' ? Colors.green.shade100 : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(report.status),
              ),
            ],
          ),
          // SizedBox(height: 2),
          // Text('Diagnosis: ${report.diagnosisReport}'),
          Text('ReportID: ${report.recordId}',style: TextStyle(fontWeight: FontWeight.w400,fontSize:12)
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text('Confidence Level: ${report.confidenceLevel}%'),
              Text(dateFormat.format(report.generatedDate)),
            ],
          ),
          // SizedBox(height: 8),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
              // IconButton(
              //   icon: Icon(Icons.visibility),
              //   onPressed: () {
              //   },
              // ),
          //     IconButton(
          //       icon: Icon(Icons.download),
          //       onPressed: () {
          //       },
          //     ),
          //   ],
          // ),
        ],
      ),
    ),
  );
}