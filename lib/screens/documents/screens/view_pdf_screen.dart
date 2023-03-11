import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ViewPdfScreen extends StatefulWidget {
  final String filePath;
  const ViewPdfScreen({
    Key? key,
    required this.filePath,
  }) : super(key: key);

  @override
  State<ViewPdfScreen> createState() => _ViewPdfScreenState();
}

class _ViewPdfScreenState extends State<ViewPdfScreen> {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: widget.filePath,
      enableSwipe: true,
      swipeHorizontal: true,
      autoSpacing: false,
      pageFling: false,
      onRender: (pages) {
        setState(() {
          pages = pages;
          isReady = true;
        });
      },
      onError: (error) {
        print(error.toString());
      },
      onPageError: (page, error) {
        print('$page: ${error.toString()}');
      },
      onViewCreated: (PDFViewController pdfViewController) {
        _controller.complete(pdfViewController);
      },
      onPageChanged: (int? page, int? total) {
        print('page change: $page/$total');
      },
    );
  }
}
