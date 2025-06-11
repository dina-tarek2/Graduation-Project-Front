import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/models/Doctor/records_list_model.dart';
import 'package:graduation_project_frontend/screens/Doctor/deadline.dart';

import 'package:graduation_project_frontend/screens/viewer.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:graduation_project_frontend/cubit/For_Doctor/records_list_cubit.dart';

class RecordsListPage extends StatefulWidget {
  static const id = "RecordsListPage";

  const RecordsListPage({Key? key}) : super(key: key);

  @override
  _RecordsListPageState createState() => _RecordsListPageState();
}

class _RecordsListPageState extends State<RecordsListPage>
    with WidgetsBindingObserver {  String searchQuery = "";
  String selectedStatus = "All";
   // handle deadline part
  DeadlineChecker? _deadlineChecker;

  @override
  void initState() {
    super.initState();
        WidgetsBinding.instance.addObserver(this); // إضافة مراقب دورة حياة التطبيق

    final userId = context.read<CenterCubit>().state;
    context.read<RecordsListCubit>().fetchRecords(userId);
    
    // تأخير إعداد مراقب المواعيد النهائية لضمان اكتمال بناء الواجهة
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   print("Setting up deadline checker after frame");
    //   setupDeadlineChecker();
    // });
  }

  void setupDeadlineChecker() {
    if (_deadlineChecker == null) {
      print("Creating new deadline checker");
      _deadlineChecker = DeadlineChecker(context);
      _deadlineChecker!.startDeadlineChecking();
    } else {
      print("Deadline checker already exists");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // التأكد من أن المدقق يعمل بعد تغيير التبعيات
    if (_deadlineChecker == null) {
      setupDeadlineChecker();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // إعادة تشغيل المدقق عند عودة التطبيق للواجهة
    if (state == AppLifecycleState.resumed) {
      print("App resumed - restarting deadline checker");
      _deadlineChecker?.stopDeadlineChecking();
      _deadlineChecker = DeadlineChecker(context);
      _deadlineChecker!.startDeadlineChecking();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // إيقاف المدقق عند توقف التطبيق مؤقتًا
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
              color: Colors.grey.withOpacity(0.2),
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
          const  SizedBox(width: 12),
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
List<String> statusOptions = [
      "All",
      "Ready",
      "Diagonize",
      "Completed",
      "Cancled"
    ];    return Wrap(
      spacing: 8,
      children: statusOptions.map((status) {
        return ChoiceChip(
  label:
              Text(status, style: const TextStyle(fontWeight: FontWeight.w600)),          selected: selectedStatus == status,
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

  Widget _buildRecordsTable() {
    return BlocConsumer<RecordsListCubit, RecordsListState>(
      listener: (context, state) {
        // إعادة فحص المواعيد النهائية كلما تغيرت البيانات
        if (state is RecordsListSuccess) {
          print("Data loaded - checking deadlines");
          _deadlineChecker?.checkDeadlines();
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
                selectedStatus == "All" || record.status == selectedStatus;

            return matchesSearch && matchesStatus;
          }).toList();

          
          // تأخير إعداد مراقب المواعيد النهائية لضمان اكتمال بناء الواجهة
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print("Setting up deadline checker after frame");
            setupDeadlineChecker();
          });

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
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 60,
                  columns: [
                    DataColumn(label: Text("Status", style: _columnStyle())),
                    DataColumn(
                        label: Text("Patient Name", style: _columnStyle())),
                    DataColumn(
                        label: Text("Study Date", style: _columnStyle())),
                    DataColumn(label: Text("Age", style: _columnStyle())),
                    DataColumn(label: Text("Body Part", style: _columnStyle())),
                    // DataColumn(label: Text("Series", style: _columnStyle())),
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
      List<dynamic> Dicom_url, String recordId) {
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

  DataRow _buildDataRow(RecordsListModel record, BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm');

    return DataRow(
      cells: [
        _clickableCell(_buildStatusIndicator(record.status), context,
            record.reportId, record.Dicom_url, record.id),
        _clickableCell(Text(record.patientName), context, record.reportId,
            record.Dicom_url, record.id),
        _clickableCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(dateFormat.format(record.studyDate),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(timeFormat.format(record.studyDate),
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            context,
            record.reportId,
            record.Dicom_url,
            record.id),
        DataCell(Text(record.age.toString())), // غير قابل للنقر
        DataCell(Text(record.bodyPartExamined ?? "N/A")), // غير قابل للنقر
        // DataCell(Text(record.series ?? "N/A")), // غير قابل للنقر
        _clickableCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(dateFormat.format(record.deadline),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red[700])),
                Text(timeFormat.format(record.deadline),
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            context,
            record.reportId,
            record.Dicom_url,
            record.id),
        _clickableCell(Text(record.modality), context, record.reportId,
            record.Dicom_url, record.id),
        _clickableCell(Text(record.centerName), context, record.reportId,
            record.Dicom_url, record.id),
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

  TextStyle _columnStyle() => TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]);
}
