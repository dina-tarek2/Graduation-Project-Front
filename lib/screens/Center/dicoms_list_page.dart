import 'dart:async';

import 'package:flutter/material.dart' hide AnimationStyle;
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/for_Center/uploaded_dicoms_cubit.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/models/Techancian/uploaded_dicoms_model.dart';
import 'package:graduation_project_frontend/screens/Center/upload_page.dart';
import 'package:graduation_project_frontend/screens/viewer.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';
import 'package:graduation_project_frontend/widgets/custom_button.dart';
import 'package:graduation_project_frontend/widgets/custom_toast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DicomsListPage extends StatefulWidget {
  static final id = "DicomsListPage";

  const DicomsListPage({super.key});

  @override
  _DicomsListPageState createState() => _DicomsListPageState();
}

class _DicomsListPageState extends State<DicomsListPage> {
  String searchQuery = "";
  String selectedStatus = "All";
  Map<String, bool> emergencyStates = {};

  bool cancelflag = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final userId = context.read<CenterCubit>().state;
    context.read<UploadedDicomsCubit>().fetchUploadedDicoms(userId);
    startAutoRefresh(); // auto refresh every 3 min
  }

  void startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 180), (timer) {
      final userId = context.read<CenterCubit>().state;
      context.read<UploadedDicomsCubit>().fetchUploadedDicoms(userId);
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); //stop timer when exit from page
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFilterSection(),
            SizedBox(height: 16),
            Expanded(child: _buildDicomsTable()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CustomButton(
              text: "Upload",
              width: 100,
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  // ignore: deprecated_member_use
                  barrierColor: Colors.black.withOpacity(0.5),
                  builder: (BuildContext context) {
                    return Center(child: UploadScreen());
                  },
                );
              },
            ),
            SizedBox(width: 12),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.348, // controls search width

              child: _buildSearchBox(),
            ),
            SizedBox(width: 12),
            _buildStatusFilterChips(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search by Name or ID",
          prefixIcon: Icon(Icons.search, color: Colors.blueGrey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: customTextStyle(14, FontWeight.normal, Colors.black87),
        onChanged: (value) {
          setState(() {
            searchQuery = value.toLowerCase();
          });
        },
      ),
    );
  }

  Widget _buildStatusFilterChips() {
    List<String> statusOptions = [
      "All",
      "Ready",
      "Diagonize",
      "Completed",
      "Cancled"
    ];
    return Wrap(
      spacing: 8,
      children: statusOptions.map((status) {
        return ChoiceChip(
          label: Text(status,
              style: customTextStyle(14, FontWeight.w600,
                  selectedStatus == status ? Colors.white : Colors.black87)),
          selected: selectedStatus == status,
          onSelected: (isSelected) {
            if (isSelected) {
              setState(() {
                selectedStatus = status;
              });
            }
          },
          // ignore: deprecated_member_use
          selectedColor: _getStatusColor(status).withOpacity(0.8),
          backgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDicomsTable() {
    return BlocConsumer<UploadedDicomsCubit, UploadedDicomsState>(
      listener: (context, state) {
        if (state is ReassignedSuccessfully) {
          showAdvancedNotification(
            context,
            message: "Record reassigned successfully!",
            type: NotificationType.success,
            style: AnimationStyle.card,
          );

          // Reload the list
          final userId = context.read<CenterCubit>().state;
          context.read<UploadedDicomsCubit>().fetchUploadedDicoms(userId);
        } else if (state is ReassignFailure) {
          showAdvancedNotification(
            context,
            message: "Failed to reassign: ${state.error}",
            type: NotificationType.error,
            style: AnimationStyle.card,
          );
        }
      },
      builder: (context, state) {
        if (state is UploadedDicomsLoading) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
            ),
          );
        } else if (state is UploadedDicomsFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 60),
                SizedBox(height: 16),
                Text(
                  "Error Loading Data",
                  style: customTextStyle(18, FontWeight.normal, Colors.red),
                ),
                Text(
                  state.error,
                  style: customTextStyle(14, FontWeight.normal, Colors.grey),
                ),
              ],
            ),
          );
        } else if (state is UploadedDicomsSuccess) {
          List<RecordModel> filteredRecords = state.dicoms.where((record) {
            bool matchesSearch =
                record.patientName.toLowerCase().contains(searchQuery) ||
                    record.id.contains(searchQuery);
            bool matchesStatus =
                selectedStatus == "All" || record.status == selectedStatus;
            return matchesSearch && matchesStatus;
          }).toList();

          if (filteredRecords.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.list_alt, color: Colors.blue[700], size: 60),
                  SizedBox(height: 16),
                  Text(
                    "No Data Available",
                    style: customTextStyle(
                        18, FontWeight.normal, Colors.grey[700]!),
                  ),
                ],
              ),
            );
          }

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 30,
                  columns: [
                    DataColumn(label: Text("Action", style: _columnStyle())),
                    DataColumn(label: Text("Emergency", style: _columnStyle())),
                    DataColumn(label: Text("Status", style: _columnStyle())),
                    DataColumn(
                        label: Text("Patient Name", style: _columnStyle())),
                    DataColumn(
                        label: Text("Study Date", style: _columnStyle())),
                    DataColumn(label: Text("Deadline", style: _columnStyle())),
                    // DataColumn(label: Text("Body Part", style: _columnStyle())),

                    DataColumn(label: Text("Modality", style: _columnStyle())),
                    DataColumn(label: Text("Doctor", style: _columnStyle())),
                    DataColumn(label: Text("QR Code", style: _columnStyle())),
                  ],
                  rows: filteredRecords
                      .map((record) => _buildDataRow(record, context))
                      .toList(),
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.list_alt, color: Colors.blue[700], size: 60),
                SizedBox(height: 16),
                Text(
                  "No Data Available",
                  style:
                      customTextStyle(18, FontWeight.normal, Colors.grey[700]!),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  DataCell _clickableCell(Widget child, BuildContext context, String reportid,
      List<dynamic> dicomUrl, String recordId) {
    return DataCell(
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => MedicalReportPage(
            //           reportId: reportid, Dicom_url: Dicom_url)),
            // );

            Navigator.pushNamed(context, DicomWebViewPage.id, arguments: {
              'reportId': reportid,
              'url': dicomUrl,
              'recordId': recordId
            });
          },
          child: child,
        ),
      ),
    );
  }

  DataRow _buildDataRow(RecordModel record, BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm');
    final String link =
        "https://abanoubsamaan5.github.io/my-react-app/#/showReport/${record.id}";
    void launchURL() async {
      final Uri url = Uri.parse(link);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $link';
      }
    }

    return DataRow(
      cells: [
        // Reassign Button if status == "Cancled"
        DataCell(
          record.status.toLowerCase() == "cancled"
              ? _buildRedirectButton(record, context)
              : Container(),
        ),
        // Emergency toggle switch
        DataCell(
          Switch(
            value: emergencyStates[record.id] ?? record.flag,
            onChanged: (val) {
              setState(() {
                emergencyStates[record.id] = val;
              });
              context.read<UploadedDicomsCubit>().updateDicomflag(
                context,
                record.id,
                {"flag": val.toString()},
              );
            },
            activeColor: Colors.red[700],
            activeTrackColor: Colors.red[100],
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[100],
            splashRadius: 20,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.red[700]!;
              }
              return Colors.grey[400]!;
            }),
            trackOutlineColor:
                WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.red[300];
              }
              return Colors.grey[300];
            }),
          ),
        ),

        // Status
        _clickableCell(
          _buildStatusIndicator(record.status),
          context,
          record.reportId,
          record.dicomUrl,
          record.id,
        ),

        // Patient Name
        _clickableCell(
          Text(
            record.patientName,
            style: customTextStyle(14, FontWeight.w600, Colors.black87),
          ),
          context,
          record.reportId,
          record.dicomUrl,
          record.id,
        ),

        // _clickableCell(
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           dateFormat.format(record.studyDate!),
        //           style: customTextStyle(14, FontWeight.bold, Colors.black),
        //         ),
        //         Text(
        //           timeFormat.format(record.studyDate!),
        //           style: customTextStyle(12, FontWeight.normal, Colors.grey),
        //         ),
        //       ],
        //     ),
        //     context,
        //     record.reportId,
        //     record.dicomUrl,
        //     record.id),

        // // Created Date & Time
        _clickableCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dateFormat.format(record.createdAt!),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                timeFormat.format(record.createdAt!),
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          context,
          record.reportId,
          record.dicomUrl,
          record.id,
        ),

        // Deadline Date & Time
        _clickableCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dateFormat.format(record.deadline!),
                  style: customTextStyle(14, FontWeight.bold, Colors.black),
                ),
                Text(
                  timeFormat.format(record.deadline!),
                  style: customTextStyle(12, FontWeight.normal, Colors.grey),
                ),
              ],
            ),
            context,
            record.reportId,
            record.dicomUrl,
            record.id),

        // Modality
        _clickableCell(
          Text(record.modality),
          context,
          record.reportId,
          record.dicomUrl,
          record.id,
        ),

        // Radiologist Name
        _clickableCell(
          Text(
            record.radiologistName == "Unknown"
                ? "Not assigned to Doctor yet"
                : record.radiologistName,
          ),
          context,
          record.reportId,
          record.dicomUrl,
          record.id,
        ),

        // QR Code Viewer
        DataCell(
          SizedBox(
            width: 50,
            height: 50,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          QrImageView(
                            data: link,
                            version: QrVersions.auto,
                            size: 300,
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: launchURL,
                            child: Text(
                              'Go to the webSite',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: QrImageView(
                data: link,
                version: QrVersions.auto,
                size: 80.0,
              ),
            ),
          ),
        ),

        // Study Date & Time

        // Body Part
        // DataCell(
        //   Text(
        //     record.bodyPartExamined ,
        //     style: customTextStyle(14, FontWeight.normal, Colors.black),
        //   ),
        // ),
      ],
    );
  }

  TextStyle _columnStyle() {
    return customTextStyle(16, FontWeight.bold, blue);
  }

  Widget _buildStatusIndicator(String status) {
    Color color = _getStatusColor(status);
    return Container(
      width: 90,
      height: 30,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        status,
        style: customTextStyle(14, FontWeight.w600, color),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "ready":
        return Colors.green;
      case "diagonize":
        return Colors.orange;
      case "completed":
        return Colors.blue;
      case "cancled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildRedirectButton(RecordModel record, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // Show confirmation dialog before reassigning
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Reassign Record"),
              content: Text(
                  "Are you sure you want to reassign this record to another doctor?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    // Close dialog
                    Navigator.of(context).pop();
                    // Call the reassign function
                    context.read<UploadedDicomsCubit>().reassign(record.id);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: Text("Reassign"),
                ),
              ],
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            // ignore: deprecated_member_use
            border: Border.all(color: Colors.red.withOpacity(0.7)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh, size: 14, color: Colors.red),
              SizedBox(width: 2),
              Text(
                "Reassign",
                style: customTextStyle(11, FontWeight.w600, Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
