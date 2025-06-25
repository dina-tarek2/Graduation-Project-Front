import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/models/Doctor/records_list_model.dart';
import 'package:graduation_project_frontend/screens/Doctor/deadline.dart';

import 'package:graduation_project_frontend/screens/viewer.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:graduation_project_frontend/cubit/For_Doctor/records_list_cubit.dart';
import 'package:graduation_project_frontend/models/Techancian/uploaded_dicoms_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/models/comments_moudel.dart';
import 'package:graduation_project_frontend/cubit/for_Center/uploaded_dicoms_cubit.dart';

class RecordsListPage extends StatefulWidget {
  static const id = "RecordsListPage";

  const RecordsListPage({Key? key}) : super(key: key);

  @override
  _RecordsListPageState createState() => _RecordsListPageState();
}

class _RecordsListPageState extends State<RecordsListPage>
    with WidgetsBindingObserver {
  String searchQuery = "";
  String selectedStatus = "All";
  // handle deadline part
  DeadlineChecker? _deadlineChecker;
  List<RecordsListModel> _currentRecords = []; // حفظ الريكوردز الحالية

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final userId = context.read<CenterCubit>().state;
    context.read<RecordsListCubit>().fetchRecords(userId);
  }

  // فانكشن محدثة لإعداد مراقب المواعيد النهائية بناءً على الشروط
  void setupDeadlineChecker() {
    // التحقق من وجود ريكوردز بحالة "Diagonize"
    bool hasDiagnoseRecords = _currentRecords
        .any((record) => record.status.toLowerCase() == "diagonize");

    if (hasDiagnoseRecords) {
      if (_deadlineChecker == null) {
        print("Creating new deadline checker - Found Diagnose records");
        _deadlineChecker = DeadlineChecker(context);
        _deadlineChecker!.startDeadlineChecking();
      } else {
        print("Deadline checker already exists for Diagnose records");
      }
    } else {
      // إيقاف المراقب إذا لم تكن هناك ريكوردز بحالة "Diagonize"
      if (_deadlineChecker != null) {
        print("No Diagnose records found - stopping deadline checker");
        _deadlineChecker!.stopDeadlineChecking();
        _deadlineChecker = null;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // لا نقوم بإعداد المراقب هنا، سيتم إعداده في BlocConsumer
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("App resumed - checking if restart needed");
      // إعادة تشغيل المراقب فقط إذا كان هناك ريكوردز بحالة "Diagonize"
      bool hasDiagnoseRecords = _currentRecords
          .any((record) => record.status.toLowerCase() == "diagonize");

      if (hasDiagnoseRecords) {
        _deadlineChecker?.stopDeadlineChecking();
        _deadlineChecker = DeadlineChecker(context);
        _deadlineChecker!.startDeadlineChecking();
        print("Deadline checker restarted for Diagnose records");
      }
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      print("App paused - stopping deadline checker");
      _deadlineChecker?.stopDeadlineChecking();
    }
  }

  @override
  void dispose() {
    print("Disposing RecordsListPage");
    _deadlineChecker?.stopDeadlineChecking();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFilterSection(),
            const SizedBox(height: 16),
            Expanded(child: _buildRecordsTable()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.4, // controls search width
              child: _buildSearchBox(),
            ),
            const SizedBox(width: 200),
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
          hintText: "Search by Name",
          prefixIcon: Icon(Icons.search, color: Colors.blueGrey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
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
<<<<<<< HEAD

    List<String> statusOptions = ["All", "Diagnose", "Completed", "Cancled"];
=======
    List<String> statusOptions = ["All", "Diagonize", "Completed", "Cancled"];
>>>>>>> 377cc5fb8b50c116a15bc2d30cb17fc263d8ee63
    return Wrap(
      spacing: 8,
      children: statusOptions.map((status) {
        return ChoiceChip(
          label:
              Text(status, style: const TextStyle(fontWeight: FontWeight.w600)),
          selected: selectedStatus == status,
          onSelected: (isSelected) {
            if (isSelected) {
              setState(() {
                selectedStatus = status;
              });
            }
          },
          selectedColor: _getStatusColor(status).withValues(alpha: 0.8),
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

  Widget _buildRecordsTable() {
    return BlocConsumer<RecordsListCubit, RecordsListState>(
      listener: (context, state) {
        if (state is RecordsListSuccess) {
          // حفظ الريكوردز الحالية
          _currentRecords = state.records;

          print("Data loaded successfully - checking for Diagnose records");

          // فحص وجود ريكوردز بحالة "Diagonize"
          bool hasDiagnoseRecords = state.records
              .any((record) => record.status.toLowerCase() == "diagonize");

          if (hasDiagnoseRecords) {
            print(
                "Found ${state.records.where((record) => record.status.toLowerCase() == "diagonize").length} Diagnose records - setting up deadline checker");

            // إعداد مراقب المواعيد النهائية
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setupDeadlineChecker();
              _deadlineChecker?.checkDeadlines();
            });
          } else {
            print("No Diagnose records found - deadline checker not needed");
            // إيقاف المراقب إذا كان يعمل
            if (_deadlineChecker != null) {
              _deadlineChecker!.stopDeadlineChecking();
              _deadlineChecker = null;
            }
          }
        } else if (state is RecordsListFailure) {
          // في حالة الفشل، إيقاف المراقب
          _currentRecords = [];
          if (_deadlineChecker != null) {
            _deadlineChecker!.stopDeadlineChecking();
            _deadlineChecker = null;
          }
        }
      },
      builder: (context, state) {
        if (state is RecordsListLoading) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
            ),
          );
        } else if (state is RecordsListFailure) {
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
        } else if (state is RecordsListSuccess) {
          List<RecordsListModel> filteredRecords =
              state.records.where((record) {
            bool matchesSearch =
                record.patientName.toLowerCase().contains(searchQuery) ||
                    record.id.contains(searchQuery);

            bool matchesStatus =
                record.status != "Ready" && selectedStatus == "All" ||
                    record.status == selectedStatus;

            return matchesSearch && matchesStatus;
          }).toList();

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 70,
                  columns: [
                    DataColumn(label: Text("Comment", style: _columnStyle())),
                    DataColumn(label: Text("Status", style: _columnStyle())),
                    DataColumn(
                        label: Text("Patient Name", style: _columnStyle())),
                    DataColumn(
                        label: Text("Created Date", style: _columnStyle())),
                    DataColumn(label: Text("Deadline", style: _columnStyle())),
                    DataColumn(label: Text("Modality", style: _columnStyle())),
                    DataColumn(label: Text("Center", style: _columnStyle())),
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
      List<dynamic> dicomUrl, String recordId) {
    return DataCell(
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
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

  DataRow _buildDataRow(RecordsListModel record, BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm');

    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (record.isEmergency) {
            return Colors.red.withValues(alpha: 0.1);
          }
          return null;
        },
      ),
      cells: [
        DataCell(
          Row(
            children: [
              if (record.isEmergency) ...[
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 6),
              ],
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size(0, 32),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  backgroundColor: Colors.blue[50],
                  foregroundColor: Colors.blue[800],
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                onPressed: () {
                  _showCommentDialog(record);
                },
                child: Text("Show Comment"),
              ),
            ],
          ),
        ),
        _clickableCell(_buildStatusIndicator(record.status), context,
            record.reportId, record.Dicom_url, record.id),
        _clickableCell(Text(record.patientName, style: TextStyle(fontSize: 13)),
            context, record.reportId, record.Dicom_url, record.id),
        _clickableCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(dateFormat.format(record.createdAt),
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Text(timeFormat.format(record.createdAt),
                    style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
            context,
            record.reportId,
            record.Dicom_url,
            record.id),
        _clickableCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(dateFormat.format(record.deadline),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700])),
                Text(timeFormat.format(record.deadline),
                    style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
            context,
            record.reportId,
            record.Dicom_url,
            record.id),
        _clickableCell(Text(record.modality, style: TextStyle(fontSize: 13)),
            context, record.reportId, record.Dicom_url, record.id),
        _clickableCell(Text(record.centerName, style: TextStyle(fontSize: 13)),
            context, record.reportId, record.Dicom_url, record.id),
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
      case "ready":
        return Colors.green;
      case "diagnose":
        return Colors.orange;
      case "completed":
        return Colors.blue;
      case "cancled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showCommentDialog(RecordsListModel record) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Comments',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue[800],
            ),
          ),
          content: FutureBuilder<List<DicomComment>>(
            future: context.read<UploadedDicomsCubit>().fetchComment(record.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final comments = snapshot.data ?? [];
                if (comments.isEmpty) {
                  return SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        "No comments available",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 450,
                  width: 500,
                  child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(comment.image),
                                  radius: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        comment.userType,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  _formatDate(comment.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...comment.dicomComments.map(
                              (c) => Container(
                                margin: EdgeInsets.only(bottom: 6),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  c,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return "${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} "
        "${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}";
  }

  TextStyle _columnStyle() => TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]);
}
