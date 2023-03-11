import 'dart:io';

import 'package:flutter/material.dart';

class DisplayFileImage extends StatelessWidget {
  final File file;
  const DisplayFileImage({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220.0,
      width: 220.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.file(
          file,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text(
                'Error loading image',
                textAlign: TextAlign.center,
              ),
            );
          },
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
              frame == 0
                  ? child
                  : const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.2,
                      ),
                    ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
