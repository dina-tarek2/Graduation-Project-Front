 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/ReportsCubit/medical_reports_cubit.dart';

Widget buildFilterButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          FilterChip(
            label: Text('All Reports'),
            onSelected: (_) => context.read<MedicalReportsCubit>().filterReportss('all'),
            selected: context.watch<MedicalReportsCubit>().state.currentFilter == 'all',
          ),
          SizedBox(width: 8),
          FilterChip(
            label: Text('Pending'),
            onSelected: (_) => context.read<MedicalReportsCubit>().filterReportss('pending'),
            selected: context.watch<MedicalReportsCubit>().state.currentFilter == 'pending',
          ),
          SizedBox(width: 8),
          FilterChip(
            label: Text('Reviewed'),
            onSelected: (_) => context.read<MedicalReportsCubit>().filterReportss
            ('Reviewed'),
            selected: context.watch<MedicalReportsCubit>().state.currentFilter == 'completed',
          ),
        ],
      ),
    );
  }