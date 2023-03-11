import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/models/document.dart';

class DocumentWidget extends StatelessWidget {
  final Document document;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final String iconPath;

  const DocumentWidget({
    super.key,
    required this.document,
    required this.onTap,
    required this.onLongPress,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10.0),
            Center(
              child: SvgPicture.asset(
                iconPath,
                height: 50.0,
                width: 50.0,
              ),
            ),
            const SizedBox(height: 10.0),
            Center(
              child: Text(
                document.fileName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
