import 'package:flutter/material.dart';

class DicomViewerPage extends StatelessWidget {
  const DicomViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dicom Viewer")),
      body: Center(
        child: Text("Viewer", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
