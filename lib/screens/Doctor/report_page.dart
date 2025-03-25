import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/For_Doctor/report_page_cubit.dart';
import 'package:graduation_project_frontend/screens/viewer.dart';

class MedicalReportPage extends StatefulWidget {
  const MedicalReportPage({super.key, this.reportId,this.Dicom_url});
  static final id = "MedicalReportPage";
  final String? reportId;
  final String? Dicom_url;

  @override
  _MedicalReportPageState createState() => _MedicalReportPageState();
}

class _MedicalReportPageState extends State<MedicalReportPage> {
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    context.read<ReportPageCubit>().fetchReport(widget.reportId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medical Report"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // يرجع لصفحة القائمة
          },
        ),
      ),
      body: BlocBuilder<ReportPageCubit, ReportPageState>(
        builder: (context, state) {
          if (state is ReportPageLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ReportPageFailure) {
            return Center(
              child: Text("Error is : ${state.errmessage}"),
            );
          } else if (state is ReportPageSuccess) {
            return Row(
              children: [
                // Main content
                Expanded(
                  child: Container(
                    color: Colors.grey[100],
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // const Text(
                              //   'Medical Report',
                              //   style: TextStyle(
                              //     fontSize: 22,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isEditing = !_isEditing;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _isEditing
                                          ? Colors.green
                                          : Colors.blueGrey,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text(_isEditing ? 'Save' : 'Edit'),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      print("hereeeee dicom url ${widget.Dicom_url}");
                                      Navigator.pushNamed(
                                        context,
                                        DicomWebViewPage.id,
                                        arguments: {
                                          'url':
                                              'http://localhost:8042/ohif/viewer?StudyInstanceUIDs=1.2.826.0.1.3680043.8.1055.1.20111103111148288.98361414.79379639',
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      foregroundColor: Colors.black54,
                                    ),
                                    child: const Text('DICOM Viewer'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),

                          // Report sections
                          const Text(
                            'Examination & Diagnosis Details',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),

                          _buildEditableSection(
                              'Impression',
                              context
                                  .read<ReportPageCubit>()
                                  .impressionController
                              //  _impressionController
                              ),
                          const SizedBox(height: 20),

                          _buildEditableSection('Findings',
                              context.read<ReportPageCubit>().findingsController
                              // _findingsController
                              ),
                          const SizedBox(height: 20),

                          _buildEditableSection('Comments & Recommendations',
                              context.read<ReportPageCubit>().commentsController
                              // _commentsController
                              ),
                          const SizedBox(height: 20),

                          // _buildEditableSection(
                          //     'Recommendations',
                          //     context
                          //         .read<ReportPageCubit>()
                          //         .recommendationsController
                          //     // _recommendationsController
                          //     ),
                          // const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else
            return const Center(
              child: Text("error in state in ui"),
            );
        },
      ),
    );
  }

  Widget _buildEditableSection(String title, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        _isEditing
            ? TextField(
                controller: controller,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              )
            : Text(
                controller.text,
                style: const TextStyle(
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }
}
