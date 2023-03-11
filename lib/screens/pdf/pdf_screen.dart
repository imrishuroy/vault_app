import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:vault_app/utils/media_util.dart';
import 'package:vault_app/widgets/loading_indicator.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({Key? key}) : super(key: key);

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  String? _filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pickedFile = await MediaUtil.pickFiles(
            context: context,
            requestType: RequestType.all,
          );
          if (pickedFile[0]?.path != null) {
            _filePath = pickedFile[0]?.path;
          }
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: _filePath != null
          ? PDFView(
              filePath: _filePath,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
              onRender: (pages) {
                setState(() {
                  // pages = _pages;
                  // isReady = true;
                });
              },
              onError: (error) {
                print(error.toString());
              },
              onPageError: (page, error) {
                print('$page: ${error.toString()}');
              },
              onViewCreated: (PDFViewController pdfViewController) {
                // _controller.complete(pdfViewController);
              },
              onPageChanged: (int? page, int? total) {
                print('page change: $page/$total');
              },
            )
          : const LoadingIndicator(),
    );
  }
}
