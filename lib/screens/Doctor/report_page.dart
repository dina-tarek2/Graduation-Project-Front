import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/For_Doctor/report_page_cubit.dart';
import 'package:graduation_project_frontend/screens/viewer.dart';

class MedicalReportPage extends StatefulWidget {
  const MedicalReportPage({super.key, this.reportId, this.Dicom_url});
  static final id = "MedicalReportPage";
  final String? reportId;
  final String? Dicom_url;

  @override
  _MedicalReportPageState createState() => _MedicalReportPageState();
}

class _MedicalReportPageState extends State<MedicalReportPage> {
  bool _isEditing = false;
  String? viewerUrl;
  void getViewerUrl() async {
    var response = await uploadDicom(widget.Dicom_url);

    if (response != null) {
      setState(() {
        viewerUrl = response['viewer_url'];
      });
    } else {
      print("❌ Failed to get Viewer URL");
    }
  }

  @override
  void initState() {
    super.initState();
    getViewerUrl();
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
                                      print("hereeeee dicom url ${viewerUrl}");
                                      Navigator.pushNamed(
                                          context, DicomWebViewPage.id,
                                          arguments: {
                                            'url': viewerUrl,
                                          });
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

  Future<Map<String, dynamic>?> uploadDicom(String? dicomUrl) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'http://localhost:5000/upload-dicom',
        data: {'dicom_url': dicomUrl},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return response.data;
         // ✅ يرجع الريسبونس بالكامل
      } else {
        print("❌ Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }
}
