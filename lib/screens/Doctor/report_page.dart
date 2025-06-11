import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/For_Doctor/records_list_cubit.dart';
import 'package:graduation_project_frontend/cubit/For_Doctor/report_page_cubit.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/widgets/mainScaffold.dart';

class MedicalReportPage extends StatefulWidget {
  const MedicalReportPage(
      {super.key, this.reportId, this.Dicom_url, this.recordId});
  static final id = "MedicalReportPage";
  final String? reportId;
  final List<dynamic>? Dicom_url;
  final String? recordId;

  @override
  _MedicalReportPageState createState() => _MedicalReportPageState();
}

class _MedicalReportPageState extends State<MedicalReportPage> {
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    context.read<ReportPageCubit>().fetchReport(widget.reportId!);
    context.read<RecordsListCubit>().getRecordById(widget.recordId!); // NEW
  }

  @override
  Widget build(BuildContext context) {
    final role = context.read<UserCubit>().state;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          "Medical Report",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          BlocBuilder<ReportPageCubit, ReportPageState>(
            builder: (context, reportState) {
              if (reportState is ReportPageSuccess) {
                return BlocBuilder<RecordsListCubit, RecordsListState>(
                  builder: (context, recordState) {
                    bool isReviewed = false;
                    if (recordState is RecordLoaded &&
                        recordState.record != null) {
                      isReviewed = recordState.record!.status == "Reviewed";
                      print("Record status: ${recordState.record!.status}");
                    }
                    print("isReviewed: $isReviewed");

                    return Row(
                      children: [
                        // زر Edit
                        if (!_isEditing)
                          TextButton.icon(
                            onPressed: isReviewed
                                ? null
                                : () {
                                    setState(() {
                                      _isEditing = true;
                                    });
                                  },
                            icon: Icon(Icons.edit,
                                color:
                                    isReviewed ? Colors.grey : Colors.black87),
                            label: Text(
                              'Edit',
                              style: TextStyle(
                                  color: isReviewed
                                      ? Colors.grey
                                      : Colors.black87),
                            ),
                          ),
                        // أزرار Cancel و Save أثناء التحرير
                        if (_isEditing) ...[
                          // زر Cancel
                          TextButton.icon(
                            onPressed: isReviewed
                                ? null
                                : _showCancelConfirmationDialog,
                            icon: Icon(Icons.cancel,
                                color: isReviewed
                                    ? Colors.grey
                                    : Colors.redAccent),
                            label: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: isReviewed
                                      ? Colors.grey
                                      : Colors.redAccent),
                            ),
                          ),
                          // زر Save
                          TextButton.icon(
                            onPressed: isReviewed
                                ? null
                                : () async {
                                    final impression = context
                                        .read<ReportPageCubit>()
                                        .impressionController
                                        .text
                                        .trim();
                                    final findings = context
                                        .read<ReportPageCubit>()
                                        .findingsController
                                        .text
                                        .trim();
                                    final comments = context
                                        .read<ReportPageCubit>()
                                        .commentsController
                                        .text
                                        .trim();

                                    await context
                                        .read<ReportPageCubit>()
                                        .updateReportOrRecord(
                                      id: widget.reportId!,
                                      isReport: true,
                                      body: {
                                        "diagnosisReportImpration":
                                            impression.isNotEmpty
                                                ? impression
                                                : " ",
                                        "diagnosisReportFinding":
                                            findings.isNotEmpty
                                                ? findings
                                                : " ",
                                        "diagnosisReportComment":
                                            comments.isNotEmpty
                                                ? comments
                                                : " ",
                                      },
                                    );

                                    setState(() {
                                      _isEditing = false;
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Report updated successfully.")),
                                    );
                                  },
                            icon: Icon(Icons.save,
                                color: isReviewed ? Colors.grey : Colors.green),
                            label: Text(
                              'Save',
                              style: TextStyle(
                                  color:
                                      isReviewed ? Colors.grey : Colors.green),
                            ),
                          ),
                        ],
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ElevatedButton(
                            onPressed: isReviewed
                                ? null
                                : () async {
                                    await context
                                        .read<ReportPageCubit>()
                                        .updateReportOrRecord(
                                      id: widget.recordId!,
                                      isReport: false,
                                      body: {"status": "Reviewed"},
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Report sent and marked as Reviewed.")),
                                    );

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              MainScaffold(role: role)),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isReviewed ? Colors.grey : Colors.indigo,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text('Send Report'),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          )
        ],
      ),
      body: BlocBuilder<ReportPageCubit, ReportPageState>(
        builder: (context, state) {
          if (state is ReportPageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReportPageFailure) {
            return Center(child: Text("Error: ${state.errmessage}"));
          } else if (state is ReportPageSuccess) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListView(
                children: [
                  _buildReportSection(
                    title: "Impression",
                    controller:
                        context.read<ReportPageCubit>().impressionController,
                  ),
                  _buildReportSection(
                    title: "Findings",
                    controller:
                        context.read<ReportPageCubit>().findingsController,
                  ),
                  _buildReportSection(
                    title: "Comments & Recommendations",
                    controller:
                        context.read<ReportPageCubit>().commentsController,
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("Unexpected state"));
          }
        },
      ),
    );
  }

  Widget _buildReportSection({
    required String title,
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _isEditing
              ? TextField(
                  controller: controller,
                  maxLines: null,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(12),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                )
              : Text(
                  controller.text.trim().isNotEmpty ? controller.text : "-",
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> _showCancelConfirmationDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Editing?"),
        content: const Text("Are you sure you want to discard your changes?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final report =
          (context.read<ReportPageCubit>().state as ReportPageSuccess).report;
      setState(() {
        _isEditing = false;
        context.read<ReportPageCubit>().impressionController.text =
            report.diagnosisReportImpression ?? "";
        context.read<ReportPageCubit>().findingsController.text =
            report.diagnosisReportFinding ?? "";
        context.read<ReportPageCubit>().commentsController.text =
            report.diagnosisReportComment ?? "";
      });
    }
  }
}
