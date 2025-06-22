import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/screens/Doctor/report_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class DicomWebViewPage extends StatefulWidget {
  final List<dynamic> url;
  final String reportId;
  final String recordId;
  static const String id = "dicom_webview_page";

  const DicomWebViewPage({
    super.key,
    required this.url,
    required this.reportId,
    required this.recordId,
  });

  @override
  State<DicomWebViewPage> createState() => _DicomWebViewPageState();
}

class _DicomWebViewPageState extends State<DicomWebViewPage> {
  InAppWebViewController? webViewController;
  String? viewerUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isWindows) {
      loadViewer();
    }
  }

  Future<Map<String, dynamic>?> uploadDicom(List<dynamic>? dicomUrl) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://57a6-156-222-136-221.ngrok-free.app/upload',
        data: {'dicom_url': dicomUrl![0]},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("❌ Server error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }

  Future<void> loadViewer() async {
    final response = await uploadDicom(widget.url);
    if (response != null && response['viewer_url'] != null) {
      setState(() {
        viewerUrl = response['viewer_url'];
        isLoading = false;
      });
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: const Text("Failed to load DICOM viewer."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isWindows) {
      return Scaffold(
        appBar: AppBar(title: const Text("DICOM Viewer")),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "DICOM Viewer is supported only on Windows platform.",
              style: TextStyle(fontSize: 18, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("DICOM Viewer"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicalReportPage(
                    reportId: widget.reportId,
                    Dicom_url: widget.url,
                    recordId: widget.recordId,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 3, 45, 105),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              foregroundColor: const Color.fromARGB(255, 230, 211, 211),
            ),
            child: const Text('Report'),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: viewerUrl == null || isLoading
          ? const Center(child: CircularProgressIndicator())
          : InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(viewerUrl!),
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
            ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:graduation_project_frontend/screens/Doctor/report_page.dart';
// import 'package:webview_windows/webview_windows.dart';

// class DicomWebViewPage extends StatefulWidget {
//   final String url;
//   final String reportId;
//   final String recordId;
//   static const String id = "dicom_webview_page";

//   const DicomWebViewPage(
//       {super.key,
//       required this.url,
//       required this.reportId,
//       required this.recordId});

//   @override
//   State<DicomWebViewPage> createState() => _DicomWebViewPageState();
// }

// class _DicomWebViewPageState extends State<DicomWebViewPage> {
//   final _controller = WebviewController();
//   bool _isInitialized = false;
//   String? viewerUrl;

//   @override
//   void initState() {
//     super.initState();
//     loadViewer();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("DICOM Viewer"),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => MedicalReportPage(
//                         reportId: widget.reportId,
//                         Dicom_url: widget.url,
//                         recordId: widget.recordId)),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color.fromARGB(255, 3, 45, 105),
//               padding: const EdgeInsets.symmetric(horizontal: 22),
//               foregroundColor: const Color.fromARGB(255, 230, 211, 211),
//             ),
//             child: const Text('Report'),
//           ),
//           const SizedBox(width: 15),
//         ],
//       ),
//       body: Stack(
//         children: [
//           // WebView
//           Positioned.fill(
//             child: _isInitialized
//                 ? Webview(_controller)
//                 : const Center(child: CircularProgressIndicator()),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<Map<String, dynamic>?> uploadDicom(String? dicomUrl) async {
//     try {
//       final dio = Dio();
//       final response = await dio.post(
//         'http://localhost:5000/upload',
//         data: {'dicom_url': dicomUrl},
//         options: Options(headers: {'Content-Type': 'application/json'}),
//       );

//       if (response.statusCode == 200) {
//         return response.data;
//       } else {
//         print("❌ Server error: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("❌ Exception: $e");
//       return null;
//     }
//   }

//   Future<void> loadViewer() async {
//     final response = await uploadDicom(widget.url);

//     if (response != null && response['viewer_url'] != null) {
//       viewerUrl = response['viewer_url'];
//       print("✅ Viewer URL: $viewerUrl");

//       await _controller.initialize();
//       await _controller.loadUrl(viewerUrl!);

//       setState(() {
//         _isInitialized = true;
//       });
//       await _controller.executeScript(
//           'window.postMessage({ type: "toast", message: "🎉" }, "*");');
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("Error"),
//           content: const Text("Failed to load DICOM viewer."),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("OK"),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }
