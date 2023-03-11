import 'package:flutter/material.dart';

class AskToAction {
  static Future<bool> confirmDelete({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    final result = await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          );
        });

    return result == true;
  }
}
