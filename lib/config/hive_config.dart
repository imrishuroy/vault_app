import 'package:hive_flutter/hive_flutter.dart';

import '/constants/app_constants.dart';
import '/enums/enums.dart';
import '/models/audio_file.dart';
import '/models/bank_details.dart';
import '/models/card_details.dart';
import '/models/category.dart';
import '/models/document.dart';
import '/models/image_file.dart';
import '/models/note.dart';
import '/models/password.dart';
import '/models/video_file.dart';

// const boxName = 'expense';

class HiveConfig {
  static Box? _box;

  factory HiveConfig() => HiveConfig._internal();

  HiveConfig._internal();

  // initializers

  Future<void> init() async {
    _box = await Hive.openBox(AppConst.vaultApp);
  }

  // final key = Hive.generateSecureKey();
  // final encryptedBox= await Hive.openBox('vaultBox', encryptionCipher: HiveAesCipher(key));
  // encryptedBox.put('secret', 'Hive is cool');
  // print(encryptedBox.get('secret'));

  void registerAdapters() {
    Hive.registerAdapter(AccountTypeAdapter());
    Hive.registerAdapter(DocumentTypeAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(CardDetailsAdapter());
    Hive.registerAdapter(PasswordAdapter());
    Hive.registerAdapter(BankDetailsAdapter());

    Hive.registerAdapter(AudioFileAdapter());

    Hive.registerAdapter(DocumentAdapter());
    Hive.registerAdapter(ImageFileAdapter());
    Hive.registerAdapter(VideoFileAdapter());
  }

  Future<void> addAppPIN(String pin) async {
    await _box?.put(AppConst.vaultPIN, pin);
  }

  String? getAppPIN() {
    return _box?.get(AppConst.vaultPIN) as String?;
  }

  bool appCodeAvailable() {
    final pin = _box?.get(AppConst.vaultPIN) as String?;
    print('Pin is $pin');
    if (pin != null && pin.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // images

  Future<void> clean(String key) async {
    final data = await _box?.get(key) ?? [];
    if (data != null || data.isNotEmpty) {
      print('this runs clean ');
      await _box?.put(key, []);
    }
  }

  Future<void> addImages(ImageFile file, {bool fromServer = false}) async {
    if (_box != null) {
      // if (fromServer) {
      //   await _box?.put(AppConst.images, []);
      // }

      final images = _box?.get(AppConst.images) ?? [];
      print('Images are $images');
      await _box?.put(AppConst.images, [...images, file]);
    }
  }

  List<ImageFile> getImages() {
    if (_box != null) {
      final images = _box?.get(AppConst.images) ?? [];
      print('Images are $images');
      return images.cast<ImageFile>();
    }
    return [];
  }

  Future<void> deleteImage(String imageId) async {
    if (_box != null) {
      final images = _box?.get(AppConst.images) ?? [];
      print('Images are $images');
      await _box?.put(AppConst.images,
          images.where((image) => image.imageId != imageId).toList());
    }
  }

  // videos

  Future<void> addVideos(VideoFile file) async {
    if (_box != null) {
      final videos = _box?.get(AppConst.videos) ?? [];
      print('Videos are $videos');
      await _box?.put(AppConst.videos, [...videos, file]);
    }
  }

  List<VideoFile> getVideos() {
    if (_box != null) {
      final videos = _box?.get(AppConst.videos) ?? [];
      print('Videos are $videos');
      return videos.cast<VideoFile>();
    }
    return [];
  }

  Future<void> deleteVideo(String videoId) async {
    if (_box != null) {
      final videos = _box?.get(AppConst.videos) ?? [];
      print('Videos are $videos');
      await _box?.put(AppConst.videos,
          videos.where((video) => video.videoId != videoId).toList());
    }
  }

  // audios

  Future<void> addAudios(AudioFile audio) async {
    if (_box != null) {
      final audios = _box?.get(AppConst.audios) ?? [];
      print('Audios are $audios');
      await _box?.put(AppConst.audios, [...audios, audio]);
    }
  }

  List<AudioFile> getAudios() {
    if (_box != null) {
      final audios = _box?.get(AppConst.audios) ?? [];
      print('Audios are $audios');
      return audios.cast<AudioFile>();
    }
    return [];
  }

  //update audio
  Future<void> updateAudio(AudioFile audio) async {
    if (_box != null) {
      final audios = _box?.get(AppConst.audios) ?? [];
      print('Audios are $audios');
      await _box?.put(
          AppConst.audios,
          audios
              .map((item) => item.audioId == audio.audioId ? audio : item)
              .toList());
    }
  }

  // delete audio
  Future<void> deleteAudio(String id) async {
    if (_box != null) {
      final audios = _box?.get(AppConst.audios) ?? [];
      print('Audios are $audios');
      await _box?.put(
          AppConst.audios, audios.where((item) => item.audioId != id).toList());
    }
  }

  // notes crud operations

  Future<void> addNote(Note note) async {
    if (_box != null) {
      final notes = _box?.get(AppConst.notes) ?? [];
      print('Notes are $notes');
      await _box?.put(AppConst.notes, [...notes, note]);
    }
  }

  Future<void> updateNote(Note note) async {
    if (_box != null) {
      final notes = _box?.get(AppConst.notes) ?? [];
      print('Notes are $notes');
      await _box?.put(
          AppConst.notes,
          notes.map((n) {
            if (n.id == note.id) {
              return note;
            }
            return n;
          }).toList());
    }
  }

  Future<void> deleteNote(String id) async {
    if (_box != null) {
      final notes = _box?.get(AppConst.notes) ?? [];

      print('Notes are $notes');
      await _box?.put(AppConst.notes, notes.where((n) => n.id != id).toList());
    }
  }

  List<Note> getAllNotes() {
    if (_box != null) {
      final notes = _box?.get(AppConst.notes) ?? [];
      print('Notes are $notes');
      return notes.cast<Note>();
    }
    return [];
  }

  Note? getNote(int id) {
    if (_box != null) {
      final notes = _box?.get(AppConst.notes) ?? [];
      print('Notes are $notes');
      return notes.firstWhere((n) => n.id == id);
    }
    return null;
  }

  // credentials crud operations

  Future<void> addCard(CardDetails cardDetails) async {
    print('Add card details -- ${cardDetails.toString()}');

    if (_box != null) {
      final cards = _box?.get(AppConst.cards) ?? [];
      print('Cards are $cards');
      await _box?.put(AppConst.cards, [...cards, cardDetails]);
    }
  }

  Future<void> updateCard(CardDetails cardDetails) async {
    if (_box != null) {
      print('Hive update credit card $cardDetails');
      final cards = _box?.get(AppConst.cards) ?? [];
      print('Cards are update card $cards');
      await _box?.put(
          AppConst.cards,
          cards.map((c) {
            if (c.cardId == cardDetails.cardId) {
              return cardDetails;
            }
            return c;
          }).toList());
    }
  }

  Future<void> deleteCard(String cardId) async {
    if (_box != null) {
      final cards = _box?.get(AppConst.cards) ?? [];

      print('Cards are $cards');
      await _box?.put(
          AppConst.cards, cards.where((c) => c.cardId != cardId).toList());
    }
  }

  List<CardDetails> getAllCards() {
    if (_box != null) {
      final cards = _box?.get(AppConst.cards) ?? [];
      print('Cards are $cards');
      return cards.cast<CardDetails>();
    }
    return [];
  }

  Future<void> addBankDetails(BankDetails bankDetails) async {
    print('this bank runs 4 ${bankDetails.toString()}');
    if (_box != null) {
      final allbankDetails = _box?.get(AppConst.bankDetails) ?? [];
      print('Cards are $allbankDetails');
      await _box?.put(AppConst.bankDetails, [...allbankDetails, bankDetails]);
    }
  }

  Future<void> updateBankDetails(BankDetails bankDetails) async {
    if (_box != null) {
      final allBankDetails = _box?.get(AppConst.bankDetails) ?? [];
      print('Cards are $allBankDetails');
      await _box?.put(
          AppConst.bankDetails,
          allBankDetails.map((bank) {
            if (bank.bankId == bankDetails.bankId) {
              return bankDetails;
            }
            return bank;
          }).toList());
    }
  }

  Future<void> deleteBankDetails(String bankId) async {
    if (_box != null) {
      final cards = _box?.get(AppConst.bankDetails) ?? [];

      print('Cards are $cards');
      await _box?.put(AppConst.bankDetails,
          cards.where((c) => c.bankId != bankId).toList());
    }
  }

  List<BankDetails> getAllBankDetails() {
    if (_box != null) {
      final cards = _box?.get(AppConst.bankDetails) ?? [];
      print('Banks are $cards');
      return cards.cast<BankDetails>();
    }
    return [];
  }

  Future<void> addPassword(Password password) async {
    print('this password runs 4 ${password.toString()}');
    if (_box != null) {
      final allPasswords = _box?.get(AppConst.passwords) ?? [];
      print('Cards are $allPasswords');
      await _box?.put(AppConst.passwords, [...allPasswords, password]);
    }
  }

  Future<void> updatePassword(Password password) async {
    if (_box != null) {
      print('Updated password ${password.toString()}');
      final allPasswords = _box?.get(AppConst.passwords) ?? [];
      print('Cards are $allPasswords');
      await _box?.put(
          AppConst.passwords,
          allPasswords.map((c) {
            if (c.passwordId == password.passwordId) {
              return password;
            }
            return c;
          }).toList());
    }
  }

  Future<void> deletePassword(String passwordId) async {
    if (_box != null) {
      final allPasswords = _box?.get(AppConst.passwords) ?? [];

      print('Cards are $allPasswords');
      await _box?.put(
          AppConst.passwords,
          allPasswords
              .where((password) => password.passwordId != passwordId)
              .toList());
    }
  }

  List<Password> getAllPasswords() {
    if (_box != null) {
      final allPaswords = _box?.get(AppConst.passwords) ?? [];
      print('Cards are $allPaswords');
      return allPaswords.cast<Password>();
    }
    return [];
  }

  // documents

  Future<void> addDocument(Document document) async {
    print('this document runs 4 ${document.toString()}');
    if (_box != null) {
      List allDocuments = [];

      if (document.documentType == DocumentType.pdf) {
        allDocuments = _box?.get(AppConst.pdfs) ?? [];
        await _box?.put(AppConst.pdfs, [...allDocuments, document]);
      } else if (document.documentType == DocumentType.excel) {
        allDocuments = _box?.get(AppConst.excels) ?? [];
        await _box?.put(AppConst.excels, [...allDocuments, document]);
      } else {
        allDocuments = _box?.get(AppConst.texts) ?? [];
        await _box?.put(AppConst.texts, [...allDocuments, document]);
      }

      print('Documents $allDocuments');
    }
  }

  // delete document
  Future<void> deleteDocument(Document document) async {
    if (_box != null) {
      List allDocuments = [];
      String path = '';
      if (document.documentType == DocumentType.pdf) {
        allDocuments = _box?.get(AppConst.pdfs) ?? [];
        path = AppConst.pdfs;
      } else if (document.documentType == DocumentType.excel) {
        allDocuments = _box?.get(AppConst.excels) ?? [];
        path = AppConst.excels;
      } else {
        allDocuments = _box?.get(AppConst.texts) ?? [];
        path = AppConst.texts;
      }

      await _box?.put(
          path,
          allDocuments
              .where((doc) => doc.documentId != document.documentId)
              .toList());

      print('Cards are $allDocuments');
    }
  }

  // get all documents

  List<Document> getPdfs() {
    if (_box != null) {
      final allPdfs = _box?.get(AppConst.pdfs) ?? [];
      print('Cards are $allPdfs');
      return allPdfs.cast<Document>();
    }
    return [];
  }

  List<Document> getExcels() {
    if (_box != null) {
      final allExcels = _box?.get(AppConst.excels) ?? [];
      print('Cards are $allExcels');
      return allExcels.cast<Document>();
    }
    return [];
  }

  List<Document> getTexts() {
    if (_box != null) {
      final allTexts = _box?.get(AppConst.texts) ?? [];
      print('Cards are $allTexts');
      return allTexts.cast<Document>();
    }
    return [];
  }

  // add document

  // List<Document> getAllDocuments(DocumentType documentType) {
  //   if (_box != null) {
  //     List allDocuments = [];

  //     print('aaaa are ${documentType.toString()}');

  //     if (documentType == DocumentType.pdf) {

  //       return (_box?.get(AppConst.pdfs) ?? []).cast<Document>();
  //       //allDocuments = _box?.get(AppConst.pdfs) ?? [];
  //     } else if (documentType == DocumentType.excel) {
  //       allDocuments = _box?.get(AppConst.excels) ?? [];
  //     } else {
  //       allDocuments = _box?.get(AppConst.texts) ?? [];
  //     }

  //     print('Documents are $allDocuments');
  //     return allDocuments.cast<Document>();
  //   }
  //   return [];
  // }
}
