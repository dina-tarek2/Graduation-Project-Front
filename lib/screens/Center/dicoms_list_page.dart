import 'dart:async';

import 'package:flutter/material.dart' hide AnimationStyle; // hide AnimationStyle from material.dart
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/for_Center/uploaded_dicoms_cubit.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:collection/collection.dart';
import 'package:graduation_project_frontend/models/Techancian/uploaded_dicoms_model.dart';
import 'package:graduation_project_frontend/models/comments_moudel.dart';
import 'package:graduation_project_frontend/screens/Center/upload_page.dart';
import 'package:graduation_project_frontend/screens/viewer.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';
import 'package:graduation_project_frontend/widgets/custom_button.dart';
import 'package:graduation_project_frontend/widgets/custom_toast.dart'; // تأكد من استيراد AnimationStyle من هنا
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// تم حذف تعريف enum AnimationStyle هنا، لضمان استخدام التعريف من custom_toast.dart


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
    // تأكد من أن CenterCubit.state هو الذي يحتوي على userId
    final userId = context.read<CenterCubit>().state;
    context.read<UploadedDicomsCubit>().fetchUploadedDicoms(userId);
    startAutoRefresh(); // auto refresh every 2 min
  }

  void startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 120), (timer) {
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
            // قسم الفلترة أصبح أكثر استجابة باستخدام Expanded و Wrap
            _buildFilterSection(),
            SizedBox(height: 16),
            Expanded(child: _buildDicomsTable()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.all(12),
      // إزالة fixed width وجعلها تتمدد حسب المساحة المتاحة
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: LayoutBuilder( // استخدام LayoutBuilder لتكييف المحتوى بناءً على العرض المتاح
        builder: (context, constraints) {
          // إذا كان العرض صغيراً جداً، اجعل الأزرار وقسم البحث في عمود
          if (constraints.maxWidth < 600) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomButton(
                  text: "Upload",
                  width: double.infinity, // يجعل الزر يأخذ العرض الكامل
                  onTap: () {
                    _showUploadDialog(context);
                  },
                ),
                SizedBox(height: 12),
                _buildSearchBox(), // سيأخذ العرض الكامل بسبب عدم وجود SizedBox بعرض ثابت
                SizedBox(height: 12),
                _buildStatusFilterChips(), // سيتم التعامل مع التفاف الشرائح بواسطة Wrap
              ],
            );
          } else {
            // للعروض الأكبر، استخدم صف
            return Row(
              children: [
                CustomButton(
                  text: "Upload",
                  width: 100, // يمكن أن يكون عرض ثابت هنا إذا كان هناك مساحة كافية
                  onTap: () {
                    _showUploadDialog(context);
                  },
                ),
                SizedBox(width: 12),
                Expanded( // استخدام Expanded لجعل مربع البحث يأخذ المساحة المتبقية
                  child: _buildSearchBox(),
                ),
                SizedBox(width: 24), // تم تعديل المسافة هنا
                // Wrap للتعامل مع التفاف الشرائح إذا كانت المساحة ضيقة
                _buildStatusFilterChips(),
              ],
            );
          }
        },
      ),
    );
  }

  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Center(
          child: ConstrainedBox( // استخدام ConstrainedBox للتحكم في حجم UploadScreen
            constraints: BoxConstraints(
              maxWidth: 800, // حد أقصى للعرض
              maxHeight: 600, // حد أقصى للارتفاع
            ),
            child: UploadScreen(),
          ),
        );
      },
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
      "Diagnose",
      "Completed",
      "Cancled"
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8, // إضافة مسافة بين الصفوف عند التفاف الشرائح
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
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView( // يسمح بالتمرير العمودي للجدول بأكمله
              scrollDirection: Axis.vertical,
              child: LayoutBuilder( // إضافة LayoutBuilder هنا
                builder: (context, constraints) {
                  return SingleChildScrollView( // يسمح بالتمرير الأفقي لـ DataTable
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox( // استخدام ConstrainedBox لجعل الجدول يملأ العرض المتاح
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                        columnSpacing: 30,
                        // تم حذف خاصية headingRowColor هنا للعودة إلى الشكل القديم
                        // تم حذف خاصية dataRowColor هنا للعودة إلى الشكل القديم
                        columns: [
                          DataColumn(label: Text("Comment", style: _columnStyle())),
                          DataColumn(label: Text("Action", style: _columnStyle())),
                          DataColumn(label: Text("Emergency", style: _columnStyle())),
                          DataColumn(label: Text("Status", style: _columnStyle())),
                          DataColumn(
                              label: Text("Patient Name", style: _columnStyle())),
                          DataColumn(
                              label: Text("Study Date", style: _columnStyle())),
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
                  );
                }
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
      List<dynamic> Dicom_url) {
    return DataCell(
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, DicomWebViewPage.id, arguments: {
              'reportId': reportid,
              'url': Dicom_url,
              'recordId': reportid
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
        // بدلاً من throw، استخدم SnackBar أو Dialog لعرض الخطأ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $link')),
        );
      }
    }

    return DataRow(
      cells: [
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min, // لجعل الأزرار لا تتمدد أكثر من اللازم
            children: [
              // زر إضافة تعليق
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size(0, 25),
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                  backgroundColor: Colors.blue[50],
                  foregroundColor: Colors.blue[800],
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                onPressed: () {
                  _addCommentDialog(record);
                },
                child: Text("+",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              SizedBox(width: 8),
              // زر عرض التعليقات
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
            onChanged: record.status.toLowerCase() == "completed" ||
                    record.status.toLowerCase() == "canceled"
                ? null // يعطل السويتش لو الحالة Completed
                : (val) {
                    setState(() {
                      emergencyStates[record.id] = val;
                    });
                    context.read<UploadedDicomsCubit>().updateDicomflag(
                          context,
                          record.id,
                          {"flag": val.toString()},
                        );
                  },
            activeColor: record.status.toLowerCase() == "completed" ||
                    record.status.toLowerCase() == "canceled"
                ? Colors.grey[400]
                : Colors.red[700],
            activeTrackColor: record.status.toLowerCase() == "completed" ||
                    record.status.toLowerCase() == "canceled"
                ? Colors.grey[200]
                : Colors.red[100],
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[100],
            splashRadius: 20,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (record.status.toLowerCase() == "completed" ||
                  record.status.toLowerCase() == "canceled") {
                return Colors.grey[200]!;
              }
              if (states.contains(WidgetState.selected)) {
                return Colors.red[700]!;
              }
              return Colors.grey[400]!;
            }),
            trackOutlineColor:
                WidgetStateProperty.resolveWith<Color?>((states) {
              if (record.status.toLowerCase() == "completed" ||
                  record.status.toLowerCase() == "canceled") {
                return Colors.grey[200];
              }
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
        ),

        // Patient Name
        _clickableCell(
          Text(
            record.patientName,
            style: customTextStyle(14, FontWeight.w600, Colors.black87),
            overflow: TextOverflow.ellipsis, // لمنع تجاوز النص
          ),
          context,
          record.reportId,
          record.dicomUrl,
        ),

        // Created Date & Time
        _clickableCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                record.createdAt != null ? dateFormat.format(record.createdAt!) : 'N/A',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                record.createdAt != null ? timeFormat.format(record.createdAt!) : '',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          context,
          record.reportId,
          record.dicomUrl,
        ),

        // Deadline Date & Time
        _clickableCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                record.deadline != null ? dateFormat.format(record.deadline!) : 'N/A',
                style: customTextStyle(14, FontWeight.bold, Colors.black),
              ),
              Text(
                record.deadline != null ? timeFormat.format(record.deadline!) : '',
                style: customTextStyle(12, FontWeight.normal, Colors.grey),
              ),
            ],
          ),
          context,
          record.reportId,
          record.dicomUrl,
        ),

        // Modality
        _clickableCell(
          Text(record.modality, overflow: TextOverflow.ellipsis),
          context,
          record.reportId,
          record.dicomUrl,
        ),

        // Radiologist Name
        _clickableCell(
          Text(
            record.radiologistName == "Unknown"
                ? "Not assigned yet"
                : record.radiologistName,
            overflow: TextOverflow.ellipsis, // لمنع تجاوز النص
          ),
          context,
          record.reportId,
          record.dicomUrl,
        ),

        // QR Code Viewer
        DataCell(
          SizedBox(
            width: 50,
            height: 50,
            child: GestureDetector(
              onTap: () {
                _showQrCodeDialog(context, link, launchURL);
              },
              child: QrImageView(
                data: link,
                version: QrVersions.auto,
                size: 80.0,
              ),
            ),
          ),
        ),
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

void _showCommentDialog(RecordModel record) {
  final ScrollController _scrollController = ScrollController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Comments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.blue[800],
          ),
        ),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.3,
          child: FutureBuilder<List<DicomComment>>(
            future: context.read<UploadedDicomsCubit>().fetchComment(record.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final comments = snapshot.data ?? [];

                if (comments.isEmpty) {
                  return Center(
                    child: Text(
                      "No comments available",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: _scrollController,
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
                                  backgroundImage: (comment.image != null &&
                                          comment.image.isNotEmpty)
                                      ? NetworkImage(comment.image)
                                      : AssetImage('assets/default_avatar.png')
                                          as ImageProvider,
                                  radius: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            ...?comment.dicomComments?.map(
                              (c) => Container(
                                margin: EdgeInsets.only(bottom: 6),
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}

String _formatDate(DateTime dateTime) {
  try {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  } catch (e) {
    return '';
  }
}





  void _addCommentDialog(RecordModel record) {
    final TextEditingController _commentController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Add Comment',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blue[800],
                ),
              ),
              content: ConstrainedBox( // استخدام ConstrainedBox للتحكم في أبعاد المحتوى
                constraints: BoxConstraints(
                  maxWidth: 500, // أقصى عرض
                  maxHeight: MediaQuery.of(context).size.height * 0.4, // أقصى ارتفاع 40% من الشاشة
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _commentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Write your comment...',
                        filled: true,
                        fillColor: Color(0xFFF8F9FA),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          final commentText = _commentController.text.trim();
                          if (commentText.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Comment cannot be empty.")),
                            );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          try {
                            await context
                                .read<UploadedDicomsCubit>()
                                .addComment(record.id, commentText);

                            Navigator.pop(context); // Close dialog
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $e")),
                            );
                          }
                        },
                  child: isLoading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Add',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showQrCodeDialog(BuildContext context, String link, VoidCallback launchUrl) {
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
                onTap: launchUrl,
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
              SizedBox(height: 10), // مسافة إضافية للزر
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
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
                    final userId = context.read<CenterCubit>().state;

                    context.read<UploadedDicomsCubit>().reassign(record.id, userId);

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
