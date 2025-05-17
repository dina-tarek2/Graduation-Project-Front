



































































import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:graduation_project_frontend/cubit/for_Center/upload_page_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/for_Center/uploaded_dicoms_cubit.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';
import 'package:graduation_project_frontend/widgets/custom_button.dart';
import 'package:graduation_project_frontend/widgets/custom_text_field.dart';


class UploadScreen extends StatelessWidget {
  static final id = "UploadScreen";
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.8,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Upload file",
                  style: customTextStyle(18, FontWeight.bold, Colors.black)),
              SizedBox(height: 12),
              DottedBorder(
                color: Colors.blue,
                strokeWidth: 1.5,
                dashPattern: [6, 3],
                borderType: BorderType.RRect,
                radius: Radius.circular(10),
                child: Container(
                  width: double.infinity,
                  height: 140,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload, size: 50, color: Colors.blue),
                      SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: "Drop your file here, or ",
                          style: customTextStyle(14, FontWeight.normal, Colors.black87),
                          children: [
                            TextSpan(
                              text: "Browse",
                              style: customTextStyle(14, FontWeight.bold, Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  final userId = context.read<CenterCubit>().state;
                                  context.read<UploadDicomCubit>().pickFiles(userId);
                                },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Supported files are .dcm",
                        style: customTextStyle(12, FontWeight.normal, Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Uploaded Files",
                  style: customTextStyle(16, FontWeight.bold, Colors.black)),
              SizedBox(height: 10),
              BlocConsumer<UploadDicomCubit, UploadDicomState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is UploadDicomLoading) {
                    return Column(
                      children: state.uploads.map((upload) {
                        return fileItem(
                          upload.fileName,
                          upload.fileSize,
                          upload.progress,
                          Colors.blue,
                        );
                      }).toList(),
                    );
                  } else if (state is UploadDicomSuccess) {
                    return Text(
                      "File Uploaded Successfully.",
                      style: customTextStyle(14, FontWeight.normal, Colors.green),
                    );
                  } else if (state is UploadDicomSummary) {
                    final userId = context.read<CenterCubit>().state;
                    context.read<UploadedDicomsCubit>().fetchUploadedDicoms(userId);
                    return Text(
                      "Total Files Uploaded: ${state.successCount} & Failed Files : ${state.failCount}",
                      style: customTextStyle(14, FontWeight.normal, Colors.black87),
                    );
                  } else {
                    return const Text("");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fileItem(
    String name,
    String size,
    double progress,
    Color color,
  ) {
    final int percentage = (progress * 100).toInt();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file, color: color, size: 30),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: customTextStyle(14, FontWeight.bold, Colors.black),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.black12,
                          color: color,
                          minHeight: 6,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "$percentage%",
                      style: customTextStyle(12, FontWeight.normal, Colors.black54),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  size,
                  style: customTextStyle(12, FontWeight.normal, Colors.black54),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Icon(Icons.delete, color: Colors.black54),
        ],
      ),
    );
  }
}
