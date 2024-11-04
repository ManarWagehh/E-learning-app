import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewerPage extends StatelessWidget {
  final String pdfUrl;

  PDFViewerPage({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Center(
        child: PDFView(
          filePath: pdfUrl,
        ),
      ),
    );
  }
}
