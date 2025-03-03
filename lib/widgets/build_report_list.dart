import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/cubit/ReportsCubit/medical_reports_state.dart';
import 'package:graduation_project_frontend/widgets/build_report_card.dart';

Widget buildReportsList(MedicalReportsState state) {
    if (state.status == MedicalReportsStatus.loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (state.status == MedicalReportsStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.errorMessage ?? 'An error occurred'),
            ElevatedButton(
              onPressed: () {
              
              },
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.reports.isEmpty) {
      return Center(child: Text('No reports found'));
    }

    return ListView.builder(
      itemCount: state.reports.length,
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final report = state.reports[index];
        return buildReportCard(report);
      },
    );
  }