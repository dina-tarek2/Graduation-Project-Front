import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/For_Doctor/records_list_cubit.dart';
import 'package:graduation_project_frontend/cubit/For_Doctor/report_page_cubit.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/models/Doctor/records_list_model.dart';
import 'package:graduation_project_frontend/models/Doctor/report_page_model.dart';
import 'package:graduation_project_frontend/widgets/custom_text_field.dart';
import 'package:graduation_project_frontend/widgets/mainScaffold.dart';

class MedicalReportPage extends StatefulWidget {
  const MedicalReportPage(
      {super.key, this.reportId, this.Dicom_url, this.recordId});
  static final id = "MedicalReportPage";

  final String? reportId;
  final String? Dicom_url;
  final String? recordId;

  @override
  _MedicalReportPageState createState() => _MedicalReportPageState();
}

class _MedicalReportPageState extends State<MedicalReportPage> {
  bool _isEditing = false;
  final List<String> reportTitles = ["Normal", "Critical", "Follow-up"];
  String? _selectedStatus;
  @override
  void initState() {
    super.initState();
    context.read<ReportPageCubit>().fetchReport(widget.reportId!);
    context.read<RecordsListCubit>().getRecordById(widget.recordId!);
    _selectedStatus =
        context.read<ReportPageCubit>().resultController.text.trim();
  }

  Widget _buildTopInfo(RecordsListModel record, ReportModel report) {
    final studyDate = record.studyDate != null
        ? record.studyDate!.toLocal().toString().split(' ').first
        : '-';
    final List<Map<String, dynamic>> items = [
      {
        'title': 'Patient Name',
        'value': record.patientName ?? '-',
        'readOnly': true
      },
      {
        'title': 'Age',
        'value': record.age?.toString() ?? '-',
        'readOnly': true
      },
      {'title': 'Gender', 'value': record.sex ?? '-', 'readOnly': true},
      {'title': 'Study Date', 'value': studyDate ?? '-', 'readOnly': true},
    ];
// العناوين (التسميات) الخاصة بالخيارات

    // Calculate each card width to fit 3 per row with spacing
    final totalPadding = 18.0 * 2; // outer padding
    final totalSpacing = 16.0 * 2; // between items
    final cardWidth =
        (MediaQuery.of(context).size.width - totalPadding - totalSpacing) / 3;

    return Wrap(spacing: 16, runSpacing: 8, children: [
      ...items.map((item) {
        return SizedBox(
          width: cardWidth,
          child: _buildReportCard(
            title: item['title']!,
            child: CustomFormTextField(
              controller: TextEditingController(text: item['value']),
              labelText: item['title'],
              readOnly: item['readOnly']!,
            ),
          ),
        );
      }).toList(),
      SizedBox(
          width: cardWidth,
          child: _buildReportCard(
            title: "Body Part",
            child: CustomFormTextField(
              controller: context.read<RecordsListCubit>().bodyPartsController,
              labelText: "Body Part",
              readOnly: !_isEditing,
            ),
          )),
      SizedBox(
          width: cardWidth,
          child: !_isEditing
              ? _buildReportCard(
                  title: "result",
                  child: CustomFormTextField(
                    controller:
                        context.read<ReportPageCubit>().resultController,
                    labelText: "result",
                    readOnly: true,
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // This makes 3 columns
                    crossAxisSpacing:
                        10, // Optional: adds spacing between columns
                    mainAxisSpacing: 10, // Optional: adds spacing between rows
                  ),
                  itemCount: reportTitles.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _buildChoseCard(reportTitles[index]);
                  },
                ))
    ]);
  }

  Widget _buildChoseCard(String value) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(115, 115, 115, 1),
                ),
              ),
            ),
            // 2. Radio for selection (يتم اختيار واحد فقط)
            Radio<String>(
              value: reportTitles.contains(value) ? value : "Normal",
              activeColor: blue,
              groupValue: reportTitles.contains(_selectedStatus)
                  ? _selectedStatus
                  : "Normal",
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatus =
                      reportTitles.contains(newValue) ? newValue! : "Normal";
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(VoidCallback onSave, VoidCallback onCancel) {
    if (_isEditing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            onPressed: onSave,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.cancel, color: Colors.red),
            label: const Text('Cancel', style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      );
    }
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: () => setState(() => _isEditing = true),
        icon: const Icon(Icons.edit),
        label: const Text('Edit'),
      ),
    );
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
                    bool isCompleted = false;
                    if (recordState is RecordLoaded &&
                        recordState.record != null) {
                      isCompleted = recordState.record!.status == "Completed";
                      print("Record status: ${recordState.record!.status}");
                    }
                    print("isCompleted: $isCompleted");

                    return Row(
                      children: [
                        // زر Edit
                        if (!_isEditing)
                          TextButton.icon(
                            onPressed: isCompleted
                                ? null
                                : () {
                                    setState(() {
                                      _isEditing = true;
                                    });
                                  },
                            icon: Icon(Icons.edit,
                                color:
                                    isCompleted ? Colors.grey : Colors.black87),
                            label: Text(
                              'Edit',
                              style: TextStyle(
                                  color: isCompleted
                                      ? Colors.grey
                                      : Colors.black87),
                            ),
                          ),
                        // أزرار Cancel و Save أثناء التحرير
                        if (_isEditing) ...[
                          // زر Cancel
                          TextButton.icon(
                            onPressed: isCompleted
                                ? null
                                : _showCancelConfirmationDialog,
                            icon: Icon(Icons.cancel,
                                color: isCompleted
                                    ? Colors.grey
                                    : Colors.redAccent),
                            label: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: isCompleted
                                      ? Colors.grey
                                      : Colors.redAccent),
                            ),
                          ),
                          // زر Save
                          TextButton.icon(
                            onPressed: isCompleted
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
                                    final result = _selectedStatus;
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
                                        "result": result,
                                      },
                                    );
                                    final newBodyPart = context
                                        .read<RecordsListCubit>()
                                        .bodyPartsController
                                        .text
                                        .trim();
                                    '';
                                    await context
                                        .read<ReportPageCubit>()
                                        .updateReportOrRecord(
                                      id: widget.recordId!,
                                      isReport: false,
                                      body: {
                                        'body_part_examined':
                                            newBodyPart.isNotEmpty
                                                ? newBodyPart
                                                : ' '
                                      },
                                    );

                                    setState(() {
                                      _isEditing = false;
                                      context
                                          .read<ReportPageCubit>()
                                          .fetchReport(widget.reportId!);
                                      context
                                          .read<RecordsListCubit>()
                                          .getRecordById(widget.recordId!);
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Report updated successfully.")),
                                    );
                                  },
                            icon: Icon(Icons.save,
                                color:
                                    isCompleted ? Colors.grey : Colors.green),
                            label: Text(
                              'Save',
                              style: TextStyle(
                                  color:
                                      isCompleted ? Colors.grey : Colors.green),
                            ),
                          ),
                        ],
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ElevatedButton(
                            onPressed: isCompleted
                                ? null
                                : () async {
                                    await context
                                        .read<ReportPageCubit>()
                                        .updateReportOrRecord(
                                      id: widget.recordId!,
                                      isReport: false,
                                      body: {"status": "Completed"},
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Report sent and marked as Completed.")),
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
                                  isCompleted ? Colors.grey : Colors.indigo,
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
        builder: (context, reportState) {
          if (reportState is ReportPageLoading)
            return const Center(child: CircularProgressIndicator());
          if (reportState is ReportPageFailure)
            return Center(child: Text('Error: \${reportState.errmessage}'));
          final report = (reportState as ReportPageSuccess).report;
          return BlocBuilder<RecordsListCubit, RecordsListState>(
            builder: (context, recordState) {
              if (recordState is! RecordLoaded || recordState.record == null) {
                return const Center(child: Text('Loading record...'));
              }
              final record = recordState.record!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    _buildTopInfo(record, report),
                    const SizedBox(height: 15),
                    // Findings
                    _buildReportCard(
                      title: 'Findings',
                      child: CustomFormTextField(
                        controller:
                            context.read<ReportPageCubit>().findingsController,
                        minLines: 3,
                        maxLines: 50,
                        labelText: 'Findings',
                        readOnly: !_isEditing,
                        isMultiline: true,
                      ),
                    ),
                    // Impression
                    _buildReportCard(
                      title: 'Impression',
                      child: CustomFormTextField(
                        controller: context
                            .read<ReportPageCubit>()
                            .impressionController,
                        minLines: 3,
                        maxLines: 50,
                        labelText: 'Impression',
                        readOnly: !_isEditing,
                        isMultiline: true,
                      ),
                    ),
                    // Comment
                    _buildReportCard(
                      title: 'Comments',
                      child: CustomFormTextField(
                        controller:
                            context.read<ReportPageCubit>().commentsController,
                        minLines: 2,
                        maxLines: 50,
                        labelText: 'Comments',
                        readOnly: !_isEditing,
                        isMultiline: true,
                      ),
                    ),
                    // Report Status Dropdown
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Section 4: Cancel Confirmation Dialog
  Future<void> _showCancelConfirmationDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel Editing?"),
        content: const Text("Discard changes to this report?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes')),
        ],
      ),
    );

    if (confirm == true) {
      final report =
          (context.read<ReportPageCubit>().state as ReportPageSuccess).report;
      final record =
          (context.read<RecordsListCubit>().state as RecordLoaded).record;
      setState(() {
        _isEditing = false;

        context.read<ReportPageCubit>().findingsController.text =
            report.diagnosisReportFinding ?? '-';
        context.read<ReportPageCubit>().impressionController.text =
            report.diagnosisReportImpression ?? '-';
        context.read<ReportPageCubit>().commentsController.text =
            report.diagnosisReportComment ?? '-';
        context.read<ReportPageCubit>().resultController.text =
            report.result ?? '-';
        context.read<RecordsListCubit>().bodyPartsController.text =
            record.bodyPartExamined ?? '-';
      });
    }
  }
}
