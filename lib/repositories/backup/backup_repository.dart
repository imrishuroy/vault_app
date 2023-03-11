import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '/config/hive_config.dart';
import '/constants/app_constants.dart';
import '/constants/paths.dart';
import '/models/audio_file.dart';
import '/models/bank_details.dart';
import '/models/card_details.dart';
import '/models/document.dart';
import '/models/failure.dart';
import '/models/image_file.dart';
import '/models/note.dart';
import '/models/password.dart';
import '/models/video_file.dart';
import '/repositories/backup/base_backup_repository.dart';
import '/utils/utils.dart';

class BackUpRepository extends BaseBackupRepository {
  final FirebaseFirestore _firestore;

  BackUpRepository({FirebaseFirestore? firestore})
      : _firestore = FirebaseFirestore.instance;

// images // videos // audios // documents // notes // credentials // contacts // bowser // home

  Future<void> backupData(String userId) async {
    try {
      backUpImages(userId: userId);
      backupVideos(userId: userId);
      backUpAudios(userId: userId);
      backUpPdfs(userId: userId);
      backupNotes(userId: userId);
      backUpCards(userId: userId);
      backUpBanks(userId: userId);
      backUpPasswords(userId: userId);
    } on Failure catch (_) {
      rethrow;
    }
  }

  Future<void> downloadData({required String userId}) async {
    try {
      await downloadImages(userId: userId);
      await downloadVideos(userId: userId);
      await downloadAudios(userId: userId);
      await downloadPDFs(userId: userId);
      await downloadNotes(userId: userId);
      await downloadCards(userId: userId);
      await downloadBanks(userId: userId);
      await downloadPasswords(userId: userId);
    } on Failure catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> backUpImages({required String userId}) async {
    try {
      final images = HiveConfig().getImages();
      if (images.isEmpty) return;
      for (ImageFile image in images) {
        final imageFile = File(image.secrectPath);
        final imageUrl = await MediaUtil.uploadMediaToStorage(
          imageFile,
          image.imageId,
          Paths.images,
        );

        print('Image url: $imageUrl');

        final imageData = image.copyWith(remoteUrl: imageUrl).toMap();
        imageData
            .addAll({'author': _firestore.collection(Paths.users).doc(userId)});

        await _firestore
            .collection(Paths.images)
            .doc(image.imageId)
            .set(imageData);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  @override
  Future<void> backupVideos({required String userId}) async {
    try {
      final videos = HiveConfig().getVideos();
      if (videos.isEmpty) return;
      for (VideoFile video in videos) {
        final videoFile = File(video.secrectPath);
        final videoUrl = await MediaUtil.uploadMediaToStorage(
            videoFile, video.videoId, Paths.videos);

        print('Video url: $videoUrl');

        final videoData = video.copyWith(remoteUrl: videoUrl).toMap();
        videoData
            .addAll({'author': _firestore.collection(Paths.users).doc(userId)});

        await _firestore
            .collection(Paths.videos)
            .doc(video.videoId)
            .set(videoData);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  @override
  Future<void> backUpAudios({required String userId}) async {
    try {
      final audios = HiveConfig().getAudios();
      if (audios.isEmpty) return;
      for (AudioFile audio in audios) {
        final audioFile = File(audio.secrectPath);
        final audioUrl = await MediaUtil.uploadMediaToStorage(
            audioFile, audio.audioId, Paths.audios);

        print('Audio url: $audioUrl');

        final audioData = audio.copyWith(remoteUrl: audioUrl).toMap();
        audioData
            .addAll({'author': _firestore.collection(Paths.users).doc(userId)});

        await _firestore
            .collection(Paths.audios)
            .doc(audio.audioId)
            .set(audioData);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  @override
  Future<void> backUpPdfs({required String userId}) async {
    try {
      final documents = HiveConfig().getPdfs();
      if (documents.isEmpty) return;
      for (Document pdf in documents) {
        final documentFile = File(pdf.secrectPath);
        final documentUrl = await MediaUtil.uploadMediaToStorage(
            documentFile, pdf.documentId, Paths.pdfs);

        print('Pdf url: $documentUrl');

        final pdftData = pdf.copyWith(remoteUrl: documentUrl).toMap();
        pdftData
            .addAll({'author': _firestore.collection(Paths.users).doc(userId)});

        await _firestore
            .collection(Paths.pdfs)
            .doc(pdf.documentId)
            .set(pdftData);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  Future<void> backUpExcels({required String userId}) async {
    try {
      final documents = HiveConfig().getExcels();
      if (documents.isEmpty) return;
      for (Document excel in documents) {
        final documentFile = File(excel.secrectPath);
        final documentUrl = await MediaUtil.uploadMediaToStorage(
            documentFile, excel.documentId, Paths.excels);

        print('Excel url: $documentUrl');

        final excelData = excel.copyWith(remoteUrl: documentUrl).toMap();
        excelData
            .addAll({'author': _firestore.collection(Paths.users).doc(userId)});

        await _firestore
            .collection(Paths.excels)
            .doc(excel.documentId)
            .set(excelData);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  Future<void> backUpTexts({required String userId}) async {
    try {
      final documents = HiveConfig().getTexts();
      if (documents.isEmpty) return;
      for (Document text in documents) {
        final documentFile = File(text.secrectPath);
        final documentUrl = await MediaUtil.uploadMediaToStorage(
            documentFile, text.documentId, Paths.texts);

        print('Pdf url: $documentUrl');

        final textData = text.copyWith(remoteUrl: documentUrl).toMap();
        textData
            .addAll({'author': _firestore.collection(Paths.users).doc(userId)});

        await _firestore
            .collection(Paths.texts)
            .doc(text.documentId)
            .set(textData);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  @override
  Future<void> backupNotes({required String userId}) async {
    try {
      final notes = HiveConfig().getAllNotes();
      if (notes.isEmpty) return;
      for (Note note in notes) {
        final noteData = note.toMap();

        noteData
            .addAll({'author': _firestore.collection(Paths.users).doc(userId)});

        await _firestore.collection(Paths.notes).doc(note.id).set(noteData);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  @override
  Future<void> backUpCards({required String userId}) async {
    try {
      final cards = HiveConfig().getAllCards();
      if (cards.isEmpty) return;
      for (CardDetails card in cards) {
        final cardData = card.toMap();

        cardData
            .addAll({'author': _firestore.collection(Paths.users).doc(userId)});

        await _firestore.collection(Paths.cards).doc(card.cardId).set(cardData);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  @override
  Future<void> backUpBanks({required String userId}) async {
    try {
      final banks = HiveConfig().getAllBankDetails();
      if (banks.isEmpty) return;
      for (BankDetails bank in banks) {
        final bankData = bank.toMap();

        bankData
            .addAll({'author': _firestore.collection(Paths.users).doc(userId)});

        await _firestore.collection(Paths.banks).doc(bank.bankId).set(bankData);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  @override
  Future<void> backUpPasswords({required String userId}) async {
    try {
      final paswords = HiveConfig().getAllPasswords();
      if (paswords.isEmpty) return;
      for (Password password in paswords) {
        final passwordData = password.toMap();

        passwordData
            .addAll({'author': _firestore.collection(Paths.users).doc(userId)});

        await _firestore
            .collection(Paths.passwords)
            .doc(password.passwordId)
            .set(passwordData);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  // download media from firebase storage

  Future<void> downloadImages({required String userId}) async {
    try {
      final images = await _firestore
          .collection(Paths.images)
          .where('author',
              isEqualTo: _firestore.collection(Paths.users).doc(userId))
          .get();

      await HiveConfig().clean(AppConst.images);

      if (images.docs.isEmpty) return;
      for (QueryDocumentSnapshot image in images.docs) {
        final imageData = image.data() as Map<String, dynamic>;

        print('Image data: $imageData');

        final imageObj = ImageFile.fromMap(imageData);

        print('Image obj: $imageObj');

        await HiveConfig().addImages(imageObj);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  Future<void> downloadVideos({required String userId}) async {
    try {
      final videos = await _firestore
          .collection(Paths.videos)
          .where('author',
              isEqualTo: _firestore.collection(Paths.users).doc(userId))
          .get();

      await HiveConfig().clean(AppConst.videos);

      if (videos.docs.isEmpty) return;
      for (QueryDocumentSnapshot video in videos.docs) {
        final videoData = video.data() as Map<String, dynamic>;

        print('Video data: $videoData');

        final videoObj = VideoFile.fromMap(videoData);

        print('Image obj: $videoObj');

        await HiveConfig().addVideos(videoObj);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  Future<void> downloadAudios({required String userId}) async {
    try {
      final audios = await _firestore
          .collection(Paths.audios)
          .where('author',
              isEqualTo: _firestore.collection(Paths.users).doc(userId))
          .get();

      await HiveConfig().clean(AppConst.audios);

      if (audios.docs.isEmpty) return;
      for (QueryDocumentSnapshot audio in audios.docs) {
        final audioData = audio.data() as Map<String, dynamic>;

        print('Audio data: $audioData');

        final audioObj = AudioFile.fromMap(audioData);

        print('Image obj: $audioObj');

        await HiveConfig().addAudios(audioObj);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  Future<void> downloadPDFs({required String userId}) async {
    try {
      final pdfs = await _firestore
          .collection(Paths.pdfs)
          .where('author',
              isEqualTo: _firestore.collection(Paths.users).doc(userId))
          .get();

      await HiveConfig().clean(AppConst.pdfs);

      if (pdfs.docs.isEmpty) return;
      for (QueryDocumentSnapshot pdf in pdfs.docs) {
        final pdfData = pdf.data() as Map<String, dynamic>;

        print('Document data: $pdfData');

        final pdfObj = Document.fromMap(pdfData);

        print('Pdf obj: $pdfObj');

        await HiveConfig().addDocument(pdfObj);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  Future<void> downloadExcels({required String userId}) async {
    try {
      final excels = await _firestore
          .collection(Paths.excels)
          .where('author',
              isEqualTo: _firestore.collection(Paths.users).doc(userId))
          .get();

      await HiveConfig().clean(AppConst.excels);

      if (excels.docs.isEmpty) return;
      for (QueryDocumentSnapshot excel in excels.docs) {
        final excelData = excel.data() as Map<String, dynamic>;

        print('Excel data: $excelData');

        final excelObj = Document.fromMap(excelData);

        print('Excel obj: $excelObj');

        await HiveConfig().addDocument(excelObj);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  Future<void> downloadTexts({required String userId}) async {
    try {
      final texts = await _firestore
          .collection(Paths.texts)
          .where('author',
              isEqualTo: _firestore.collection(Paths.users).doc(userId))
          .get();

      await HiveConfig().clean(AppConst.texts);

      if (texts.docs.isEmpty) return;
      for (QueryDocumentSnapshot text in texts.docs) {
        final textData = text.data() as Map<String, dynamic>;

        print('Text data: $textData');

        final textObj = Document.fromMap(textData);

        print('Excel obj: $textObj');

        await HiveConfig().addDocument(textObj);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

// credentials

  Future<void> downloadBanks({required String userId}) async {
    try {
      final banks = await _firestore
          .collection(Paths.documents)
          .where('author',
              isEqualTo: _firestore.collection(Paths.users).doc(userId))
          .get();

      await HiveConfig().clean(AppConst.banks);

      if (banks.docs.isEmpty) return;
      for (QueryDocumentSnapshot bank in banks.docs) {
        final bankData = bank.data() as Map<String, dynamic>;

        print('Bank data: $bankData');

        final bankObj = BankDetails.fromMap(bankData);

        print('bank obj: $bankObj');

        await HiveConfig().addBankDetails(bankObj);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  Future<void> downloadCards({required String userId}) async {
    try {
      final cards = await _firestore
          .collection(Paths.documents)
          .where('author',
              isEqualTo: _firestore.collection(Paths.users).doc(userId))
          .get();

      await HiveConfig().clean(AppConst.cards);

      if (cards.docs.isEmpty) return;
      for (QueryDocumentSnapshot card in cards.docs) {
        final cardData = card.data() as Map<String, dynamic>;

        print('Card data: $cardData');

        final cardObj = CardDetails.fromMap(cardData);

        print('card obj: $cardObj');

        await HiveConfig().addCard(cardObj);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  Future<void> downloadPasswords({required String userId}) async {
    try {
      final passwords = await _firestore
          .collection(Paths.passwords)
          .where('author',
              isEqualTo: _firestore.collection(Paths.users).doc(userId))
          .get();

      await HiveConfig().clean(AppConst.passwords);

      if (passwords.docs.isEmpty) return;
      for (QueryDocumentSnapshot password in passwords.docs) {
        final passwordData = password.data() as Map<String, dynamic>;

        print('Password data: $passwordData');

        final passwordObj = Password.fromMap(passwordData);

        print('Password obj: $passwordObj');

        await HiveConfig().addPassword(passwordObj);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }

  Future<void> downloadNotes({required String userId}) async {
    try {
      final notes = await _firestore
          .collection(Paths.notes)
          .where('author',
              isEqualTo: _firestore.collection(Paths.users).doc(userId))
          .get();

      await HiveConfig().clean(AppConst.notes);

      if (notes.docs.isEmpty) return;
      for (QueryDocumentSnapshot note in notes.docs) {
        final noteData = note.data() as Map<String, dynamic>;

        print('Note data: $noteData');

        final noteObj = Note.fromMap(noteData);

        print('Note obj: $noteObj');

        await HiveConfig().addNote(noteObj);
      }
    } catch (error) {
      print('Error: $error');
      throw Failure(message: error.toString());
    }
  }
}
