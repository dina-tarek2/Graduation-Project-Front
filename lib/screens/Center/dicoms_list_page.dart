// import 'package:flutter/material.dart';
// import 'package:graduation_project_frontend/cubit/for_Center/uploaded_dicoms_cubit.dart';
// import 'package:graduation_project_frontend/cubit/login_cubit.dart';
// import 'package:graduation_project_frontend/models/Techancian/uploaded_dicoms_model.dart';
// import 'package:graduation_project_frontend/screens/Center/upload_page.dart';
// import 'package:graduation_project_frontend/screens/viewer.dart';
// import 'package:graduation_project_frontend/widgets/custom_button.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class DicomsListPage extends StatefulWidget {
//   static final id = "DicomsListPage";

//   const DicomsListPage({super.key});

//   @override
//   _DicomsListPageState createState() => _DicomsListPageState();
// }

// class _DicomsListPageState extends State<DicomsListPage> {
//   String searchQuery = "";
//   String selectedStatus = "All";

//   @override
//   void initState() {
//     super.initState();
//     final userId = context.read<CenterCubit>().state;
//     context.read<UploadedDicomsCubit>().fetchUploadedDicoms(userId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildFilterSection(),
//             SizedBox(height: 16),
//             Expanded(child: _buildDicomsTable()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterSection() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Container(
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             CustomButton(
//               text: "Upload",
//               width: 100,
//               onTap: () {
//                 showDialog(
//                   context: context,
//                   barrierDismissible: true,
//                   barrierColor: Colors.black.withOpacity(0.5),
//                   builder: (BuildContext context) {
//                     return Center(
//                         child: UploadScreen()); // دي الصفحة اللي كانت عادية
//                   },
//                 );
//               },
//             ),
//             SizedBox(width: 12),
//             SizedBox(
//               width: MediaQuery.of(context).size.width *
//                   0.4, // controls search width
//               child: _buildSearchBox(),
//             ),
//             SizedBox(width: 12),
//             _buildStatusFilterChips(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBox() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: "Search by Name or ID",
//           prefixIcon: Icon(Icons.search, color: Colors.blueGrey),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         ),
//         onChanged: (value) {
//           setState(() {
//             searchQuery = value.toLowerCase();
//           });
//         },
//       ),
//     );
//   }

//   Widget _buildStatusFilterChips() {
//     List<String> statusOptions = ["All", "Ready", "Diagonize", "Completed","Canceled"];
//     return Wrap(
//       spacing: 8,
//       children: statusOptions.map((status) {
//         return ChoiceChip(
//           label: Text(status, style: TextStyle(fontWeight: FontWeight.w600)),
//           selected: selectedStatus == status,
//           onSelected: (isSelected) {
//             if (isSelected) {
//               setState(() {
//                 selectedStatus = status;
//               });
//             }
//           },
//           selectedColor: _getStatusColor(status).withOpacity(0.8),
//           backgroundColor: Colors.grey[300],
//           labelStyle: TextStyle(
//             color: selectedStatus == status ? Colors.white : Colors.black87,
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildDicomsTable() {
//     return BlocBuilder<UploadedDicomsCubit, UploadedDicomsState>(
//       builder: (context, state) {
//         if (state is UploadedDicomsLoading) {
//           return Center(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
//             ),
//           );
//         } else if (state is UploadedDicomsFailure) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.error_outline, color: Colors.red, size: 60),
//                 SizedBox(height: 16),
//                 Text(
//                   "Error Loading Data",
//                   style: TextStyle(color: Colors.red, fontSize: 18),
//                 ),
//                 Text(
//                   state.error,
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ],
//             ),
//           );
//         } else if (state is UploadedDicomsSuccess) {
//           List<RecordModel> filteredRecords = state.dicoms.where((record) {
//             bool matchesSearch =
//                 record.patientName.toLowerCase().contains(searchQuery) ||
//                     record.id.contains(searchQuery);
//             bool matchesStatus =
//                 selectedStatus == "All" || record.status == selectedStatus;
//             return matchesSearch && matchesStatus;
//           }).toList();

//           return Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   columnSpacing: 60,
//                   columns: [
//                     DataColumn(label: Text("Status", style: _columnStyle())),
//                     DataColumn(
//                         label: Text("Patient Name", style: _columnStyle())),
//                     DataColumn(
//                         label: Text("Study Date", style: _columnStyle())),
//                     DataColumn(label: Text("Age", style: _columnStyle())),
//                     DataColumn(label: Text("Body Part", style: _columnStyle())),
//                     // DataColumn(label: Text("Series", style: _columnStyle())),
//                     DataColumn(label: Text("Deadline", style: _columnStyle())),
//                     DataColumn(label: Text("Modality", style: _columnStyle())),
//                     DataColumn(label: Text("Doctor", style: _columnStyle())),
//                   ],
//                   rows: filteredRecords
//                       .map((record) => _buildDataRow(record, context))
//                       .toList(),
//                 ),
//               ),
//             ),
//           );
//         } else {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.list_alt, color: Colors.blue[700], size: 60),
//                 SizedBox(height: 16),
//                 Text(
//                   "No Data Available",
//                   style: TextStyle(color: Colors.grey[700], fontSize: 18),
//                 ),
//               ],
//             ),
//           );
//         }
//       },
//     );
//   }

//   DataCell _clickableCell(
//       Widget child, BuildContext context, String reportid, String Dicom_url) {
//     return DataCell(
//       MouseRegion(
//         cursor: SystemMouseCursors.click, // يجعل المؤشر يتغير عند المرور فوقه
//         child: GestureDetector(
//           onTap: () {
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(
//             //       builder: (context) => MedicalReportPage(
//             //           reportId: reportid, Dicom_url: Dicom_url)),
//             // );
//             Navigator.pushNamed(context, DicomWebViewPage.id, arguments: {
//               'reportId': reportid,
//               'url': Dicom_url,
//             });
//           },
//           child: child,
//         ),
//       ),
//     );
//   }

//   DataRow _buildDataRow(RecordModel record, BuildContext context) {
//     final dateFormat = DateFormat('yyyy-MM-dd');
//     final timeFormat = DateFormat('HH:mm');

//     return DataRow(
//       cells: [
//         _clickableCell(_buildStatusIndicator(record.status), context,
//             record.reportId, record.dicomUrl),
//         _clickableCell(Text(record.patientName), context, record.reportId,
//             record.dicomUrl),
//         _clickableCell(
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(dateFormat.format(record.studyDate!),
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 Text(timeFormat.format(record.studyDate!),
//                     style: TextStyle(color: Colors.grey, fontSize: 12)),
//               ],
//             ),
//             context,
//             record.reportId,
//             record.dicomUrl),
//         DataCell(Text(record.age.toString())), // غير قابل للنقر
//         DataCell(Text(record.bodyPartExamined ?? "N/A")), // غير قابل للنقر
//         // DataCell(Text(record.series ?? "N/A")), // غير قابل للنقر
//         _clickableCell(
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(dateFormat.format(record.deadline!),
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.red[700])),
//                 Text(timeFormat.format(record.deadline!),
//                     style: TextStyle(color: Colors.grey, fontSize: 12)),
//               ],
//             ),
//             context,
//             record.reportId,
//             record.dicomUrl),
//         _clickableCell(
//             Text(record.modality), context, record.reportId, record.dicomUrl),
//         _clickableCell(Text(record.radiologistName), context, record.reportId,
//             record.dicomUrl),
//       ],
//     );
//   }

//   Widget _buildStatusIndicator(String status) {
//     Color statusColor = _getStatusColor(status);

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: statusColor.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CircleAvatar(
//             radius: 5,
//             backgroundColor: statusColor,
//           ),
//           SizedBox(width: 6),
//           Text(
//             status,
//             style: TextStyle(
//               color: statusColor,
//               fontWeight: FontWeight.bold,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case "ready":
//         return Colors.green;
//       case "diagonize":
//         return Colors.orange;
//       case "completed":
//         return Colors.blue;
//       case "canceled":
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   TextStyle _columnStyle() => TextStyle(
//       fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]);
// }




























































import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/for_Center/uploaded_dicoms_cubit.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/models/Techancian/uploaded_dicoms_model.dart';
import 'package:graduation_project_frontend/screens/Center/upload_page.dart';
import 'package:graduation_project_frontend/screens/viewer.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';
import 'package:graduation_project_frontend/widgets/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DicomsListPage extends StatefulWidget {
  static final id = "DicomsListPage";

  const DicomsListPage({super.key});

  @override
  _DicomsListPageState createState() => _DicomsListPageState();
}

class _DicomsListPageState extends State<DicomsListPage> {
  String searchQuery = "";
  String selectedStatus = "All";

  @override
  void initState() {
    super.initState();
    final userId = context.read<CenterCubit>().state;
    context.read<UploadedDicomsCubit>().fetchUploadedDicoms(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // backgroundColor: sky,
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
                    return Center(child: UploadScreen());
                  },
                );
              },
            ),
            SizedBox(width: 12),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
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
    List<String> statusOptions = ["All", "Ready", "Diagonize", "Completed", "Canceled"];
    return Wrap(
      spacing: 8,
      children: statusOptions.map((status) {
        return ChoiceChip(
          label: Text(status, style: customTextStyle(14, FontWeight.w600, selectedStatus == status ? Colors.white : Colors.black87)),
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

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              //color: sky,
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
                    DataColumn(label: Text("Patient Name", style: _columnStyle())),
                    DataColumn(label: Text("Study Date", style: _columnStyle())),
                    DataColumn(label: Text("Age", style: _columnStyle())),
                    DataColumn(label: Text("Body Part", style: _columnStyle())),
                    DataColumn(label: Text("Deadline", style: _columnStyle())),
                    DataColumn(label: Text("Modality", style: _columnStyle())),
                    DataColumn(label: Text("Doctor", style: _columnStyle())),
                  ],
                  rows: filteredRecords.map((record) => _buildDataRow(record, context)).toList(),
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
                  style: customTextStyle(18, FontWeight.normal, Colors.grey[700]!),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  DataCell _clickableCell(Widget child, BuildContext context, String reportid, String Dicom_url) {
    return DataCell(
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, DicomWebViewPage.id, arguments: {
              'reportId': reportid,
              'url': Dicom_url,
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

    return DataRow(
      cells: [
        _clickableCell(_buildStatusIndicator(record.status), context, record.reportId, record.dicomUrl),
        _clickableCell(Text(record.patientName, style: customTextStyle(14, FontWeight.w600, Colors.black87)), context, record.reportId, record.dicomUrl),
        _clickableCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(dateFormat.format(record.studyDate!), style: customTextStyle(14, FontWeight.bold, Colors.black)),
              Text(timeFormat.format(record.studyDate!), style: customTextStyle(12, FontWeight.normal, Colors.grey)),
            ],
          ),
          context,
          record.reportId,
          record.dicomUrl,
        ),
        DataCell(Text(record.age.toString(), style: customTextStyle(14, FontWeight.normal, Colors.black))),
        DataCell(Text(record.bodyPartExamined ?? "N/A", style: customTextStyle(14, FontWeight.normal, Colors.black))),
        _clickableCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(dateFormat.format(record.deadline!), style: customTextStyle(14, FontWeight.bold, Colors.black)),
              Text(timeFormat.format(record.deadline!), style: customTextStyle(12, FontWeight.normal, Colors.grey)),
            ],
          ),
          context,
          record.reportId,
          record.dicomUrl,
        ),
        DataCell(Text(record.modality ?? "N/A", style: customTextStyle(14, FontWeight.normal, Colors.black))),
        DataCell(Text(record.radiologistName ?? "N/A", style: customTextStyle(14, FontWeight.normal, Colors.black))),
      ],
    );
  }

  TextStyle _columnStyle() {
    //return customTextStyle(16, FontWeight.bold, Colors.blue[700]!);
      return customTextStyle(16, FontWeight.bold, blue);

  }

  Widget _buildStatusIndicator(String status) {
    Color color = _getStatusColor(status);
    return Container(
      width: 90,
      height: 30,
      decoration: BoxDecoration(
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
    switch (status) {
      case "Ready":
        return Colors.green;
      case "Diagonize":
        return Colors.blue;
      case "Completed":
        return Colors.orange;
      case "Canceled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
