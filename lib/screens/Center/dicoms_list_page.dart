import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/cubit/for_Center/uploaded_dicoms_cubit.dart';
import 'package:graduation_project_frontend/models/Doctor/records_list_model.dart';
import 'package:graduation_project_frontend/models/Techancian/uploaded_dicoms_model.dart';
import 'package:graduation_project_frontend/screens/Center/upload_page.dart';
import 'package:graduation_project_frontend/screens/Doctor/report_page.dart';
import 'package:graduation_project_frontend/screens/viewer.dart';
import 'package:graduation_project_frontend/widgets/custom_button.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<UploadedDicomsCubit>().fetchUploadedDicoms();
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
                  barrierColor: Colors.black.withOpacity(0.5),
                  builder: (BuildContext context) {
                    return Center(
                        child: UploadScreen()); // دي الصفحة اللي كانت عادية
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
        onChanged: (value) {
          setState(() {
            searchQuery = value.toLowerCase();
          });
        },
      ),
    );
  }

  Widget _buildStatusFilterChips() {
    List<String> statusOptions = ["All", "Available", "Pending", "Completed"];
    return Wrap(
      spacing: 8,
      children: statusOptions.map((status) {
        return ChoiceChip(
          label: Text(status, style: TextStyle(fontWeight: FontWeight.w600)),
          selected: selectedStatus == status,
          onSelected: (isSelected) {
            if (isSelected) {
              setState(() {
                selectedStatus = status;
              });
            }
          },
          selectedColor: _getStatusColor(status).withOpacity(0.8),
          backgroundColor: Colors.grey[300],
          labelStyle: TextStyle(
            color: selectedStatus == status ? Colors.white : Colors.black87,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDicomsTable() {
    return BlocBuilder<UploadedDicomsCubit, UploadedDicomsState>(
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
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
                Text(
                  state.error,
                  style: TextStyle(color: Colors.grey),
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

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
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
                  columnSpacing: 55,
                  columns: [
                    DataColumn(label: Text('Emergency', style: _columnStyle())),
                    DataColumn(label: Text("Status", style: _columnStyle())),
                    DataColumn(
                        label: Text("Patient Name", style: _columnStyle())),
                    DataColumn(
                        label: Text("Created Date", style: _columnStyle())),
                    // DataColumn(label: Text("Age", style: _columnStyle())),
                    // DataColumn(label: Text("Body Part", style: _columnStyle())),
                    // DataColumn(label: Text("Series", style: _columnStyle())),
                    DataColumn(label: Text("Deadline", style: _columnStyle())),
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
                  style: TextStyle(color: Colors.grey[700], fontSize: 18),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  DataCell _clickableCell(Widget child, BuildContext context, String reportid,
      String Dicom_url, String recordId) {
    return DataCell(
      MouseRegion(
        cursor: SystemMouseCursors.click, // يجعل المؤشر يتغير عند المرور فوقه
        child: GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => MedicalReportPage(
            //           reportId: reportid, Dicom_url: Dicom_url)),
            // );
            print('reportId: $reportid, Dicom_url: $Dicom_url');
            Navigator.pushNamed(context, DicomWebViewPage.id, arguments: {
              'reportId': reportid,
              'url': Dicom_url,
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
    final String LINK =
        "https://abanoubsamaan5.github.io/my-react-app/#/showReport/${record.id}" ??
            "This QR not found";
    void _launchURL() async {
      final Uri url = Uri.parse(LINK);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $LINK';
      }
    }

    bool isEmergency = false;
    return DataRow(
      cells: [
        DataCell(
          Switch(
            value: emergencyStates[record.id] ?? record.flag ?? false,
            onChanged: (val) {
              setState(() {
                emergencyStates[record.id] = val;
              });
              context
                  .read<UploadedDicomsCubit>()
                  .updateDicomflag(context, record.id, {"flag": val.toString()});
              print('Emergency toggled to $val for report: ${record.id}');
            },
            activeColor: Colors.red[700],
            activeTrackColor: Colors.red[100],
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[100],
            splashRadius: 20,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.red[700]!;
              }
              return Colors.grey[400]!;
            }),
            trackOutlineColor:
                MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.red[300];
              }
              return Colors.grey[300];
            }),
          ),
        ),

        _clickableCell(_buildStatusIndicator(record.status), context,
            record.reportId, record.dicomUrl, record.id),
        _clickableCell(Text(record.patientName), context, record.reportId,
            record.dicomUrl, record.id),
        _clickableCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(dateFormat.format(record.createdAt!),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(timeFormat.format(record.createdAt!),
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            context,
            record.reportId,
            record.dicomUrl, record.id),
        // DataCell(Text(record.age.toString())), // غير قابل للنقر
        // DataCell(Text(record.bodyPartExamined ?? "N/A")), // غير قابل للنقر
        // DataCell(Text(record.series ?? "N/A")), // غير قابل للنقر
        _clickableCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(dateFormat.format(record.deadline!),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red[700])),
                Text(timeFormat.format(record.deadline!),
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            context,
            record.reportId,
            record.dicomUrl, record.id),
        _clickableCell(
            Text(record.modality), context, record.reportId, record.dicomUrl, record.id),
        _clickableCell(Text(record.radiologistName), context, record.reportId,
            record.dicomUrl, record.id),
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
                            data: LINK,
                            version: QrVersions.auto,
                            size: 300, // حجم أكبر
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: _launchURL,
                            child: Text(
                              'QR Code: $LINK',
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
                data: LINK,
                version: QrVersions.auto,
                size: 80.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color statusColor = _getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 5,
            backgroundColor: statusColor,
          ),
          SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "available":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "completed":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  TextStyle _columnStyle() => TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]);
}
