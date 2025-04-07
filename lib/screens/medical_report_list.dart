import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/api_services/dio_consumer.dart';
import 'package:graduation_project_frontend/cubit/ReportsCubit/medical_reports_cubit.dart';
import 'package:graduation_project_frontend/cubit/ReportsCubit/medical_reports_state.dart';
import 'package:graduation_project_frontend/repositories/medical_repository.dart';
import 'package:graduation_project_frontend/widgets/build_report_list.dart';
import 'package:graduation_project_frontend/widgets/build_states_card.dart';

class MedicalReportsScreen extends StatelessWidget {
  static String id ='MedicalReportsScreen';

  const MedicalReportsScreen({super.key});
  @override
  Widget build(BuildContext context) {
     return BlocProvider(
           create: (context) => MedicalReportsCubit(repository: 
      MedicalRepository(api: DioConsumer(dio: Dio())))..fetchReports(), 
           child: BlocBuilder<MedicalReportsCubit, MedicalReportsState>(
        builder: (context, state) {
          return Scaffold(
   body: Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reports Overview',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
          Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildStatsCard(
                        icon: Icons.description,
                        title: 'Total Reports',
                        value: '${state.totalReports}',
                        color: Colors.blue.shade100,
                      ),
                      buildStatsCard(
                        icon: Icons.pending_actions,
                        title: 'Pending Reports',
                        value: '${state.reports.where((r) => r.status == "Pending").length}',
                        color: Colors.orange.shade100,
                      ),
                      buildStatsCard(
                        icon: Icons.check_circle_outline,
                        title: 'Reports Reviewed',
                        value: '${state.reports.where((r) => r.status == "Reviewed").length}',
                        color: Colors.green.shade100,
                        // actionText: 'Download all',
                      ),
                    ],
                  ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search reports...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => context.read<MedicalReportsCubit>().searchReports(value),
            ),
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: Text('All Reports'),
                    selected: state.currentFilter == 'all',
                    onSelected: (_) => context.read<MedicalReportsCubit>().filterReportss('all'),
                    selectedColor: Colors.blue.shade100,
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text('Pending'),
                    selected: state.currentFilter == 'pending',
                    onSelected: (_) => context.read<MedicalReportsCubit>().filterReportss('pending'),
                    selectedColor: Colors.orange.shade100,
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text('Reviewed'),
                    selected: state.currentFilter == 'Reviewed',
                    onSelected: (_) => context.read<MedicalReportsCubit>().filterReportss('Reviewed'),
                    selectedColor: Colors.green.shade100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<MedicalReportsCubit>().fetchReports();
          },
          child: buildReportsList(state),
        ),
      ),
    ],
  ),
);
   } )
       );}
        }