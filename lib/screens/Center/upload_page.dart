//

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:graduation_project_frontend/cubit/for_Center/upload_page_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/for_Center/uploaded_dicoms_cubit.dart';
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
        // width: 1400,
        width: screenWidth * 0.5,
        height: screenHeight * 0.5,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Upload file",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                        children: [
                          TextSpan(
                            text: "Browse",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                  
                                context.read<UploadDicomCubit>().pickFiles();
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text("Supported files are .dcm",
                        style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Uploaded Files",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            BlocConsumer<UploadDicomCubit, UploadDicomState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is UploadDicomLoading) {
                  return fileItem(state.fileName, state.fileSize,
                      state.progress, Colors.blue);
                } 
                // else if (state is UploadDicomInitial) {
                //   return const Text("");
                // }
                 else if (state is UploadDicomSuccess) {
                  return const Text(
                    "File Uploaded Succeffully.",
                  );
                } 
                else if (state is UploadDicomSummary) {
                  context.read<UploadedDicomsCubit>().fetchUploadedDicoms();
                  return Text(
                    "Total Files Uploaded: ${state.successCount} & Failed Files : ${state.failCount}",
                  );
                }
                else {
                  return const Text("");
                }
              },
            ),
            // fileItem("Price Analys", "Excel", "8.5MB", 1.0, Colors.green),
            // SizedBox(height: 20), // مسافة صغيرة قبل الزر
            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.grey,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(6),
            //       ),
            //     ),
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //       context.read<UploadDicomCubit>().cancelUpload();
            //     },
            //     child: Text("Close", style: TextStyle(color: Colors.white)),
            //   ),
            // ),
          ],
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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                          minHeight: 6, // 👈 خفضنا الطول شوية
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "$percentage%",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  size,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
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

// class UploadButtonScreen extends StatelessWidget {
//   static String id = 'UploadButtonScreen';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Upload Dicom")),
//       body: BlocConsumer<UploadDicomCubit, UploadDicomState>(
//         listener: (context, state) {},
//         builder: (context, state) {
//           return Center(
//             child:
//                 // ElevatedButton(
//                 //   onPressed: () {
//                 //     showDialog(
//                 //       context: context,
//                 //       barrierDismissible: true,
//                 //       barrierColor: Colors.black.withOpacity(0.5),
//                 //       builder: (BuildContext context) {
//                 //         return Center(
//                 //             child: UploadScreen()); // دي الصفحة اللي كانت عادية
//                 //       },
//                 //     );
//                 //   },
//                 //   child: Text("Upload"),
//                 // ),
//                 CustomButton(
//               text: "Upload",
//               width: 100,
//               onTap: () {
//                 showDialog(
//                       context: context,
//                       barrierDismissible: true,
//                       barrierColor: Colors.black.withOpacity(0.5),
//                       builder: (BuildContext context) {
//                         return Center(
//                             child: UploadScreen()); // دي الصفحة اللي كانت عادية
//                       },
//                     );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
