import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

class ViewEcxelcreen extends StatelessWidget {
  final String path;
  final String fileName;

  const ViewEcxelcreen({
    super.key,
    required this.path,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    print('excel path: $path');
    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
      ),
      body: FutureBuilder(
        future: loadingCsvData(path),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          print(snapshot.data.toString());
          return snapshot.hasData
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: snapshot.data
                            ?.map(
                              (data) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      data[0].toString(),
                                    ),
                                    Text(
                                      data[1].toString(),
                                    ),
                                    Text(
                                      data[2].toString(),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList() ??
                        [],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  Future<List<List<dynamic>>> loadingCsvData(String path) async {
    final csvFile = File(path).openRead();
    print('Csv file: $csvFile');
    return await csvFile
        .transform(utf8.decoder)
        .transform(
          const CsvToListConverter(),
        )
        .toList();
  }
}
