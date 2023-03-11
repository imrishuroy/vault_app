import '/constants/app_constants.dart';
import '/models/category.dart';

List<Category> categories = [
  const Category(
    name: AppConst.images,
    icon: 'assets/icons/image.svg',
  ),
  const Category(
    name: AppConst.videos,
    icon: 'assets/icons/video.svg',
  ),

  const Category(
    name: AppConst.audios,
    icon: 'assets/icons/audio.svg',
  ),

  const Category(
    name: AppConst.documents,
    icon: 'assets/icons/document.svg',
  ),

  const Category(
    name: AppConst.notes,
    icon: 'assets/icons/notes.svg',
  ),
  const Category(
    name: AppConst.credentials,
    icon: 'assets/icons/credentials.svg',
  ),

  const Category(
    name: AppConst.privateBrowser,
    icon: 'assets/icons/browser.svg',
  ),

  // add
  // contanct
];
