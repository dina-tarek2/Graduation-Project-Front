import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart'; // Assuming this defines custom colors
import 'package:graduation_project_frontend/cubit/For_Doctor/records_list_cubit.dart';
import 'package:graduation_project_frontend/cubit/For_Doctor/report_page_cubit.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart'; // Assuming UserCubit is part of login_cubit.dart
import 'package:graduation_project_frontend/models/Doctor/records_list_model.dart';
import 'package:graduation_project_frontend/models/Doctor/report_page_model.dart';
import 'package:graduation_project_frontend/widgets/custom_text_field.dart'; // Assuming this is your custom text field
import 'package:graduation_project_frontend/widgets/mainScaffold.dart'; // Assuming this is your main scaffold

class MedicalReportPage extends StatefulWidget {
  const MedicalReportPage({
    super.key,
    this.reportId,
    this.Dicom_url, // Consider renaming to dicomUrls for Dart conventions
    this.recordId,
  });

  static const String id = "MedicalReportPage"; // Use const for static final

  final String? reportId;
  final List<dynamic>? Dicom_url; // This variable is not used in the provided code
  final String? recordId;

  @override
  _MedicalReportPageState createState() => _MedicalReportPageState();
}

class _MedicalReportPageState extends State<MedicalReportPage>
    with TickerProviderStateMixin {
  // Renamed for clarity and consistency
  bool _isEditingReport = false;
  final List<String> _reportStatusOptions = ["Normal", "Critical", "Follow-up"];
  String? _selectedReportStatus;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Local Controllers to manage text field state independently from Cubit's rebuilds
  late TextEditingController _findingsController;
  late TextEditingController _impressionController;
  late TextEditingController _commentsController;
  late TextEditingController _bodyPartsController;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Initialize local Controllers
    _findingsController = TextEditingController();
    _impressionController = TextEditingController();
    _commentsController = TextEditingController();
    _bodyPartsController = TextEditingController();

    // Initial default status
    _selectedReportStatus = "Normal";

    // Fetch initial data - actual controller texts will be set in BlocListeners
    if (widget.reportId != null) {
      context.read<ReportPageCubit>().fetchReport(widget.reportId!);
    }
    if (widget.recordId != null) {
      context.read<RecordsListCubit>().getRecordById(widget.recordId!);
    }

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    // Dispose local Controllers
    _findingsController.dispose();
    _impressionController.dispose();
    _commentsController.dispose();
    _bodyPartsController.dispose();
    super.dispose();
  }

  /// Builds the custom app bar for the medical report page.
  SliverAppBar _buildModernAppBar(bool isRecordCompleted, String role) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      flexibleSpace: FlexibleSpaceBar(
        // Adjusted left padding to make space for the back icon
        titlePadding: const EdgeInsets.only(left: 80.0, bottom: 16), // Increased left padding
        title: const Text(
          'Medical Report',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        background: Container(
          // Correct way to use LinearGradient with BoxDecoration
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade50,
                Colors.indigo.shade50,
              ],
            ),
          ),
        ),
      ),
      actions: [_buildActionButtons(isRecordCompleted, role)],
    );
  }

  /// Builds the action buttons shown in the app bar (Edit, Cancel, Send, Save).
  Widget _buildActionButtons(bool isRecordCompleted, String role) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Radiologist actions when not editing and report not completed
          if (!_isEditingReport && role == "Radiologist") ...[
            // Updated to ElevatedButton.icon for text with icon
            ElevatedButton.icon(
              onPressed: isRecordCompleted ? null : () => _toggleEditing(true),
              icon: Icon(Icons.edit_rounded, color: isRecordCompleted ? Colors.grey.shade400 : Colors.blue.shade600),
              label: Text(
                'Edit',
                style: TextStyle(
                  color: isRecordCompleted ? Colors.grey.shade400 : Colors.blue.shade800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.blue.shade300, width: 0.8),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
            const SizedBox(width: 10),
            // Updated to ElevatedButton.icon for text with icon
            ElevatedButton.icon(
              onPressed: isRecordCompleted ? null : () => _showDoctorCancelDialog(context, role),
              icon: Icon(Icons.cancel_rounded, color: isRecordCompleted ? Colors.grey.shade400 : Colors.red.shade600),
              label: Text(
                'Cancel',
                style: TextStyle(
                  color: isRecordCompleted ? Colors.grey.shade400 : Colors.red.shade800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.red.shade300, width: 0.8),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
            const SizedBox(width: 10),
            // Updated to ElevatedButton.icon for text with icon
            ElevatedButton.icon(
              onPressed: isRecordCompleted ? null : () => _sendReport(role),
              icon: Icon(Icons.send_rounded, color: isRecordCompleted ? Colors.grey.shade400 : Colors.green.shade600),
              label: Text(
                'Send',
                style: TextStyle(
                  color: isRecordCompleted ? Colors.grey.shade400 : Colors.green.shade800, // Fixed: Used isRecordCompleted
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.green.shade300, width: 0.8),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
          // Actions when actively editing the report (still icon-only as per previous design)
          if (_isEditingReport) ...[
            _buildModernIconButton(
              icon: Icons.close_rounded,
              onPressed: _showCancelConfirmationDialog,
              color: Colors.red.shade600,
              tooltip: 'Cancel Changes',
            ),
            const SizedBox(width: 10),
            _buildModernIconButton(
              icon: Icons.check_rounded,
              onPressed: _saveChanges,
              color: Colors.green.shade600,
              tooltip: 'Save Changes',
            ),
          ],
        ],
      ),
    );
  }

  /// Helper widget to build a consistent modern icon button with custom styling.
  Widget _buildModernIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent, // Ensures the InkWell splash effect is visible
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: onPressed != null ? color.withOpacity(0.1) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: onPressed != null ? color.withOpacity(0.3) : Colors.grey.shade300,
              ),
            ),
            child: Icon(
              icon,
              color: onPressed != null ? color : Colors.grey.shade400,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the patient information section as a modern card.
  Widget _buildPatientInfoSection(RecordsListModel record) {
    final studyDate = record.studyDate != null
        ? record.studyDate!.toLocal().toString().split(' ').first
        : '-';

    return _buildModernCard(
      title: 'Patient Information',
      icon: Icons.person_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // Aligns patient icon/study date and status box in one row
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.date_range_rounded,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Study Date: $studyDate',
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Moved _buildStatusSection here
              if (!_isEditingReport) // Only show when not editing
                _buildStatusSection(),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoGrid(record),
        ],
      ),
    );
  }

  /// Builds a grid display for patient and study information.
  Widget _buildInfoGrid(RecordsListModel record) {
    // List of info items, including editable 'Body Part'
    final items = [
      {'label': 'Name', 'value': record.patientName ?? '-', 'icon': Icons.person_outline, 'editable': false},
      {'label': 'Age', 'value': record.age?.toString() ?? '-', 'icon': Icons.cake_outlined, 'editable': false},
      {'label': 'Gender', 'value': record.sex ?? '-', 'icon': Icons.wc_outlined, 'editable': false},
      {'label': 'Body Part', 'value': record.bodyPartExamined ?? '-', 'icon': Icons.accessibility_new_rounded, 'editable': false},
    ];

    return GridView.builder(
      shrinkWrap: true, // Takes only the space it needs
      physics: const NeverScrollableScrollPhysics(), // Disables scrolling for the grid itself
      // Adjusted childAspectRatio to make boxes less tall and more compact
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Two columns
        childAspectRatio: 3.2, // Adjusted for slightly taller boxes to fit larger text, smaller than 7.0 but larger than 4.0
        crossAxisSpacing: 8, // Reduced horizontal spacing
        mainAxisSpacing: 8, // Reduced vertical spacing
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildInfoTile(
          label: item['label'] as String,
          value: item['value'] as String,
          icon: item['icon'] as IconData,
          isEditable: item['editable'] as bool,
        );
      },
    );
  }

  /// Builds a single information tile, which can be editable or read-only.
  Widget _buildInfoTile({
    required String label,
    required String value,
    required IconData icon,
    bool isEditable = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(8), // Further reduced padding for compactness
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        // Applied subtle blue border and a more visible shadow for a modern look
        border: Border.all(color: Colors.blue.shade100, width: 0.8), // Subtle blue border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // Slightly more visible shadow
            blurRadius: 10, // Increased blur for softness
            offset: const Offset(0, 4), // Larger offset for more depth
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
        children: [
          Row(
            children: [
              Icon(icon, size: 23, color: Colors.grey.shade600), // Larger icon
              const SizedBox(width: 4), // Increased spacing
              Text(
                label,
                style: TextStyle(
                  fontSize: 20, // Larger font for label
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6), // Increased spacing
          if (isEditable)
          // CustomFormTextField for editable body part.
          // Assumes CustomFormTextField handles its own internal styling
          // and doesn't need external 'style' or 'fillColor' parameters.
            Expanded( // Ensures the text field expands correctly within the row
              child: CustomFormTextField(
                controller: _bodyPartsController,
                labelText: null, // Set to null if the design doesn't require a floating label
                readOnly: !_isEditingReport,
                isMultiline: false, // Body Part is expected to be a single line
              ),
            )
          else
            Text(
              value,
              style: const TextStyle(
                fontSize: 16, // Larger font for value
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  /// Builds the report status section, displaying status or allowing selection when editing.
  Widget _buildStatusSection() {
    debugPrint('Building _buildStatusSection. _isEditingReport: $_isEditingReport, _selectedReportStatus: $_selectedReportStatus');
    // When not editing, return the compact status display
    if (!_isEditingReport) {
      return Container(
        margin: const EdgeInsets.only(left: 8), // Small left margin to separate from text/icon
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Very compact padding
        decoration: BoxDecoration(
          color: _getStatusColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _getStatusColor().withOpacity(0.3)),
          boxShadow: [ // Add a subtle shadow to the small status box
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Keep row content compact
          children: [
            Icon(_getStatusIcon(), color: _getStatusColor(), size: 25), // Smaller icon for very compact box
            const SizedBox(width: 15), // Smaller spacing
            Text(
              _selectedReportStatus ?? 'Normal',
              style: TextStyle(
                fontSize: 18, // Smaller font for very compact box
                fontWeight: FontWeight.w600,
                color: _getStatusColor(),
              ),
            ),
          ],
        ),
      );
    }
    // When editing, return the full card for status selection (radio buttons)
    return _buildModernCard(
      title: 'Select Status',
      icon: Icons.radio_button_checked_rounded,
      child: Column(
        children: _reportStatusOptions.map((status) => _buildStatusOption(status)).toList(),
      ),
    );
  }

  /// Builds a single radio button option for status selection.
  Widget _buildStatusOption(String status) {
    final isSelected = _selectedReportStatus == status;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedReportStatus = status;
            // debugPrint('Selected Status: $_selectedReportStatus');
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer( // Provides smooth visual feedback on selection
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.blue.shade300 : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isSelected ? Colors.blue.shade600 : Colors.grey.shade400,
              ),
              const SizedBox(width: 12),
              Text(
                status,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.blue.shade800 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A common card layout structure for different sections of the report.
  Widget _buildModernCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.blue.shade700, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  /// Builds a text field for report details (Findings, Impression, Comments).
  Widget _buildReportField({
    required String title,
    required IconData icon,
    required TextEditingController controller,
    int minLines = 3,
    int maxLines = 10,
  }) {
    return _buildModernCard(
      title: title,
      icon: icon,
      child: CustomFormTextField(
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        labelText: title, // Use title as label for these multi-line fields
        readOnly: !_isEditingReport,
        isMultiline: true,
      ),
    );
  }

  /// Determines the color associated with a given report status.
  Color _getStatusColor() {
    switch (_selectedReportStatus) {
      case 'Critical':
        return Colors.red.shade600;
      case 'Follow-up':
        return Colors.orange.shade600;
      default:
        return Colors.green.shade600;
    }
  }

  /// Determines the icon associated with a given report status.
  IconData _getStatusIcon() {
    switch (_selectedReportStatus) {
      case 'Critical':
        return Icons.warning_rounded;
      case 'Follow-up':
        return Icons.schedule_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  /// Toggles the editing mode for the report, triggering a UI rebuild.
  void _toggleEditing(bool editing) {
    setState(() {
      _isEditingReport = editing;
      debugPrint('Editing mode toggled to: $_isEditingReport');
    });
  }

  /// Handles saving changes made to the report and record.
  Future<void> _saveChanges() async {
    _showLoadingDialog(); // Show loading indicator

    try {
      final impression = _impressionController.text.trim();
      final findings = _findingsController.text.trim();
      final comments = _commentsController.text.trim();
      final result = _selectedReportStatus;

      // Update the report details
      await context.read<ReportPageCubit>().updateReportOrRecord(
        id: widget.reportId!,
        isReport: true,
        body: {
          "diagnosisReportImpration": impression.isNotEmpty ? impression : " ",
          "diagnosisReportFinding": findings.isNotEmpty ? findings : " ",
          "diagnosisReportComment": comments.isNotEmpty ? comments : " ",
          "result": result,
        },
      );

      // Update the body part examined in the record
      final newBodyPart = _bodyPartsController.text.trim();
      await context.read<ReportPageCubit>().updateReportOrRecord(
        id: widget.recordId!,
        isReport: false,
        body: {'body_part_examined': newBodyPart.isNotEmpty ? newBodyPart : ' '},
      );

      // Re-fetch data to ensure UI reflects the latest state from the backend
      await context.read<ReportPageCubit>().fetchReport(widget.reportId!);
      await context.read<RecordsListCubit>().getRecordById(widget.recordId!);

      setState(() {
        _isEditingReport = false; // Exit editing mode
        // Update the local status variable from the cubit's updated result
        _selectedReportStatus = context.read<ReportPageCubit>().resultController.text.trim();
      });

      if (mounted) Navigator.pop(context); // Close loading dialog
      _showSuccessSnackBar("Report updated successfully");
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading dialog
      _showErrorSnackBar("Failed to update report: $e");
    }
  }

  /// Handles sending the report by marking the record as 'Completed'.
  Future<void> _sendReport(String role) async {
    _showLoadingDialog(); // Show loading indicator

    try {
      await context.read<ReportPageCubit>().updateReportOrRecord(
        id: widget.recordId!,
        isReport: false,
        body: {"status": "Completed", "flag": false}, // Mark record as completed
      );

      if (mounted) Navigator.pop(context); // Close loading dialog
      _showSuccessSnackBar("Report sent and marked as Completed");

      // Navigate back to the main scaffold after successful submission
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainScaffold(role: role)),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading dialog
      _showErrorSnackBar("Failed to send report: $e");
    }
  }

  /// Shows a customizable success snack bar.
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)), // Ensures message fits on smaller screens
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating, // Makes the snack bar float above content
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12), // Adds space around the snack bar
      ),
    );
  }

  /// Shows a customizable error snack bar.
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  /// Shows a generic circular progress indicator loading dialog.
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // User must wait for operation to complete
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the user role once from the cubit's state
    final role = context.read<UserCubit>().state;
    debugPrint('Building MedicalReportPage. Current editing mode: $_isEditingReport, Selected status: $_selectedReportStatus');

    return MultiBlocListener(
      listeners: [
        BlocListener<ReportPageCubit, ReportPageState>(
          listener: (context, reportState) {
            if (reportState is ReportPageSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  // Update controller texts from cubit data
                  _findingsController.text = reportState.report.diagnosisReportFinding ?? '';
                  _impressionController.text = reportState.report.diagnosisReportImpression ?? '';
                  _commentsController.text = reportState.report.diagnosisReportComment ?? '';

                  // Update _selectedReportStatus if not in editing mode
                  if (!_isEditingReport) {
                    setState(() {
                      _selectedReportStatus = reportState.report.result ?? 'Normal';
                    });
                  }
                }
              });
            }
          },
        ),
        BlocListener<RecordsListCubit, RecordsListState>(
          listener: (context, recordState) {
            if (recordState is RecordLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _bodyPartsController.text = recordState.record.bodyPartExamined ?? '';
                }
              });
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: BlocBuilder<ReportPageCubit, ReportPageState>(
          builder: (context, reportState) {
            if (reportState is ReportPageLoading) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 3),
              );
            }

            if (reportState is ReportPageFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${reportState.errmessage}',
                      style: TextStyle(color: Colors.red.shade600, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (widget.reportId != null) {
                          context.read<ReportPageCubit>().fetchReport(widget.reportId!);
                        }
                        if (widget.recordId != null) {
                          context.read<RecordsListCubit>().getRecordById(widget.recordId!);
                        }
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Tap to Retry"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue.shade600,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              );
            }

            // If ReportPageSuccess, we have the report data
            if (reportState is ReportPageSuccess) {
              final report = reportState.report;
              // Controllers' texts are updated via BlocListener now.
              // _selectedReportStatus is also handled by BlocListener for non-editing mode.

              // Now, build the UI that depends on both report and record states
              return BlocBuilder<RecordsListCubit, RecordsListState>(
                builder: (context, recordState) {
                  if (recordState is! RecordLoaded) {
                    return const Center(child: CircularProgressIndicator(strokeWidth: 3));
                  }

                  final record = recordState.record;
                  final isRecordCompleted = record.status == "Completed";
                  // _bodyPartsController.text is updated via BlocListener now.

                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: CustomScrollView(
                      slivers: [
                        _buildModernAppBar(isRecordCompleted, role), // AppBar
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              // The status section is now displayed conditionally within _buildPatientInfoSection
                              // OR separately as a full selection card when editing.
                              _buildPatientInfoSection(record),
                              // Only show status selection card when editing, outside the Patient Info box
                              if (_isEditingReport)
                                _buildStatusSection(), // This now shows the radio buttons for selection

                              _buildReportField(
                                title: 'Findings',
                                icon: Icons.search_rounded,
                                controller: _findingsController,
                              ),
                              _buildReportField(
                                title: 'Impression',
                                icon: Icons.psychology_rounded,
                                controller: _impressionController,
                              ),
                              _buildReportField(
                                title: 'Comments',
                                icon: Icons.comment_rounded,
                                controller: _commentsController,
                                minLines: 2,
                                maxLines: 8,
                              ),
                              const SizedBox(height: 100), // Bottom padding for scrollability
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            // Fallback in case of an unhandled state (should ideally not be reached)
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// Shows a confirmation dialog for a doctor to cancel a report, with an optional comment.
  void _showDoctorCancelDialog(BuildContext context, String role) {
    final TextEditingController cancelCommentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.cancel_rounded, color: Colors.red.shade600),
              const SizedBox(width: 8),
              const Text("Cancel Report"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Are you sure you want to cancel this report?"),
              const SizedBox(height: 16),
              TextField(
                controller: cancelCommentController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Comment (optional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Dismiss dialog
              child: const Text("Keep Report"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!mounted) return; // Check if widget is still in tree
                Navigator.of(context).pop(); // Close the dialog first
                _showLoadingDialog(); // Show loading indicator

                try {
                  final cancelComment = cancelCommentController.text.trim();
                  await context.read<ReportPageCubit>().updateReportOrRecord(
                    id: widget.recordId!,
                    isReport: false,
                    body: {
                      "status": "Cancelled",
                      "flag": false, // Assuming flag should be false on cancellation
                      "cancelComment": cancelComment.isNotEmpty ? cancelComment : null,
                    },
                  );
                  if (mounted) Navigator.pop(context); // Close loading dialog
                  _showSuccessSnackBar("Report cancelled successfully");
                  if (mounted) {
                    // Navigate back after successful cancellation
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => MainScaffold(role: role)),
                    );
                  }
                } catch (e) {
                  if (mounted) Navigator.pop(context); // Close loading dialog
                  _showErrorSnackBar("Failed to cancel report: $e");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Confirm Cancel"),
            ),
          ],
        );
      },
    );
  }

  /// Shows a confirmation dialog when a user tries to cancel editing.
  Future<void> _showCancelConfirmationDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Cancel Editing?"),
        content: const Text("Your changes will be discarded. Are you sure you want to cancel?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // User chooses to keep editing
            child: const Text('Keep Editing'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true), // User confirms discarding changes
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Discard Changes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Revert controllers to the original values from the cubit's state.
      // This assumes the cubits retain the original fetched data before edits.
      final reportState = context.read<ReportPageCubit>().state;
      final recordState = context.read<RecordsListCubit>().state;

      if (reportState is ReportPageSuccess && recordState is RecordLoaded) {
        setState(() {
          _isEditingReport = false; // Exit editing mode
          _findingsController.text = reportState.report.diagnosisReportFinding ?? '';
          _impressionController.text = reportState.report.diagnosisReportImpression ?? '';
          _commentsController.text = reportState.report.diagnosisReportComment ?? '';
          _selectedReportStatus = reportState.report.result ?? 'Normal';
          _bodyPartsController.text = recordState.record.bodyPartExamined ?? '';
        });
      }
    }
  }
}
