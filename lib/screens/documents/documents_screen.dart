import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/enums/document_type.dart';
import '/repositories/documents/documents_repository.dart';
import '/screens/documents/cubit/documents_cubit.dart';
import '/screens/documents/widgets/pdf_widget.dart';
import '/screens/documents/widgets/txt_widget.dart';
import 'widgets/excel_widget.dart';

class DocumentsScreen extends StatefulWidget {
  static const String routeName = '/documents';

  const DocumentsScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => DocumentsCubit(
          documentsRepo: context.read<DocumentsRepository>(),
        ),
        child: const DocumentsScreen(),
      ),
    );
  }

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<DocumentsCubit>().loadDocument();
    // _tabController.animateTo(2);
  }

  @override
  Widget build(BuildContext context) {
    final docsCubit = context.read<DocumentsCubit>();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_tabController.index == 0) {
              docsCubit.pickDocument(documentType: DocumentType.pdf);
            } else if (_tabController.index == 1) {
              docsCubit.pickDocument(documentType: DocumentType.excel);
            } else {
              docsCubit.pickDocument(documentType: DocumentType.txt);
            }
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          title: const Text('Documents'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(FontAwesomeIcons.filePdf),
                text: 'PDFs',
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.fileExcel),
                text: 'Excels',
              ),
              Tab(
                icon: Icon(Icons.text_format),
                text: 'Texts',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            PdfWidget(),
            ExcelWidget(),
            TxtWidget(),
          ],
        ),
      ),
    );
  }
}
