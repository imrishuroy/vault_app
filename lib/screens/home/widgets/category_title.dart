import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/constants/app_constants.dart';
import '/models/category.dart';
import '/screens/audios/audios_screen.dart';
import '/screens/bowser/screens/private_browser_screen.dart';
import '/screens/credentials/credentials_screen.dart';
import '/screens/documents/documents_screen.dart';
import '/screens/images/images_screen.dart';
import '/screens/notes/notes_screen.dart';
import '/screens/videos/videos_screen.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  const CategoryTile({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed(_navigationPath(category.name)),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(),
              child: SvgPicture.asset(
                category.icon,
                height: 70.0,
                width: 70.0,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(category.name),
          ],
        ),
      ),
    );
  }

  String _navigationPath(String name) {
    switch (name) {
      case AppConst.images:
        return ImagesScreen.routeName;
      case AppConst.videos:
        return VideosScreen.routeName;
      case AppConst.notes:
        return NotesScreen.routeName;
      case AppConst.credentials:
        return CredentialsScreen.routeName;
      case AppConst.audios:
        return AudiosScreen.routeName;
      case AppConst.documents:
        return DocumentsScreen.routeName;
      case AppConst.privateBrowser:
        return PrivateBrowserScreen.routeName;

      default:
        return 'error';
    }
  }
}
