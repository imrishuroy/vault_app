import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:vault_app/services/services.dart';

import '/constants/app_constants.dart';
import '/screens/documents/cubit/documents_cubit.dart';
import '/widgets/error_dialog.dart';
import '/widgets/loading_indicator.dart';
import 'document_wdget.dart';

class TxtWidget extends StatelessWidget {
  const TxtWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final docCubit = context.read<DocumentsCubit>();
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
                  itemCount: state.textDocumentsList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                  ),
                  itemBuilder: (context, index) {
                    final txt = state.textDocumentsList[index];
                    return DocumentWidget(
                      document: txt,
                      onTap: () async => await OpenFile.open(txt.secrectPath),
                      onLongPress: () async {
                        final result = await AskToAction.confirmDelete(
                          context: context,
                          title: 'Delete Text',
                          message: 'Do you want to delete this text?',
                        );

                        if (result) {
                          docCubit.deleteDocument(txt);
                        }
                      },
                      iconPath: AppConst.assets.txtIcon,
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
