import 'package:flutter/material.dart';
import '../viewer.dart'; // استيراد الصفحة الجديدة

class MedicalReportPage extends StatefulWidget {
  const MedicalReportPage({super.key});
  static final id = "MedicalReportPage";

  @override
  _MedicalReportPageState createState() => _MedicalReportPageState();
}

class _MedicalReportPageState extends State<MedicalReportPage> {
  bool _isEditing = false;

  // default /original one values
  final TextEditingController _impressionController = TextEditingController(
      text:
          'Findings are suggestive of mild bronchitis, with no radiological evidence of pneumonia or lung masses.');
  final TextEditingController _findingsController = TextEditingController(
      text:
          'The chest X-ray shows increased bronchovascular markings in both lung fields.\nNo evidence of consolidation, pleural effusion, or pneumothorax is seen.\nThe cardiac silhouette and mediastinum appear within normal limits.\nThe costophrenic angles are clear.');
  final TextEditingController _commentsController = TextEditingController(
      text:
          'The current study does not show signs of acute infection, but clinical symptoms should be evaluated in conjunction with these findings.\nComparison with previous X-rays (if available) would be helpful to assess for any progression.');
  final TextEditingController _recommendationsController = TextEditingController(
      text:
          'Clinical correlation is advised to confirm bronchitis (consider pulmonary function tests if symptoms persist).\nIf symptoms worsen, a follow-up X-ray in 2-4 weeks is recommended.\nSmoking cessation is strongly advised if the patient is a smoker.');

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
      body: Row(
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
                                backgroundColor:
                                    _isEditing ? Colors.green : Colors.blueGrey,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(_isEditing ? 'Save' : 'Edit'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  DicomWebViewPage.id,
                                  arguments: {
                                    'url':
                                        'http://localhost:8042/ohif/viewer?StudyInstanceUIDs=1.2.826.0.1.3680043.8.1055.1.20111103111148288.98361414.79379639',
                                  },
                                );
                              },
                              child: const Text("DICOM Viewer"),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Report sections
                    const Text(
                      'Examination & Diagnosis Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    _buildEditableSection('Impression', _impressionController),
                    const SizedBox(height: 20),

                    _buildEditableSection('Findings', _findingsController),
                    const SizedBox(height: 20),

                    _buildEditableSection('Comments', _commentsController),
                    const SizedBox(height: 20),

                    _buildEditableSection(
                        'Recommendations', _recommendationsController),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
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
