import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:vault_app/screens/documents/widgets/document_wdget.dart';
import 'package:vault_app/services/services.dart';

import '/constants/app_constants.dart';
import '/screens/documents/cubit/documents_cubit.dart';
import '/widgets/error_dialog.dart';
import '/widgets/loading_indicator.dart';

class ExcelWidget extends StatelessWidget {
  const ExcelWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final docCubit = BlocProvider.of<DocumentsCubit>(context);
    return BlocConsumer<DocumentsCubit, DocumentsState>(
      listener: (context, state) {
        if (state.status == DocumentsStatus.error) {
          showDialog(
            context: context,
            builder: (_) => ErrorDialog(
              content: state.failure.message,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == DocumentsStatus.loading) {
          return const LoadingIndicator();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  itemCount: state.excelDocumentsList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                  ),
                  itemBuilder: (context, index) {
                    final excel = state.excelDocumentsList[index];
                    return DocumentWidget(
                      document: excel,
                      onTap: () async {
                        await OpenFile.open(excel.secrectPath);
                      },
                      // onTap: () => Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (_) => ViewEcxelcreen(
                      //       fileName: excel.fileName,
                      //       path: excel.secrectPath,
                      //     ),
                      //   ),
                      // ),
                      onLongPress: () async {
                        final result = await AskToAction.confirmDelete(
                          context: context,
                          title: 'Delete Excel',
                          message: 'Do you want to delete this excel?',
                        );

                        if (result) {
                          docCubit.deleteDocument(excel);
                        }
                      },
                      iconPath: AppConst.assets.excelIcon,
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
