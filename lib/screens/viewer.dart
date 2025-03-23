import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

class DicomWebViewPage extends StatefulWidget {
  final String url;
  static const String id = "dicom_webview_page";

  const DicomWebViewPage({super.key, required this.url});

  @override
  State<DicomWebViewPage> createState() => _DicomWebViewPageState();
}

class _DicomWebViewPageState extends State<DicomWebViewPage> {
  final _controller = WebviewController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    initWebView();
  }

  Future<void> initWebView() async {
    await _controller.initialize();
    await _controller.loadUrl(widget.url);
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DICOM Viewer"),
      ),
      body: Center(
        child: _isInitialized
            ? Webview(_controller)
            : const CircularProgressIndicator(),
      ),
    );
  }
}
