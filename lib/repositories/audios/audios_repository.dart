import 'package:hive_flutter/hive_flutter.dart';

import '/config/hive_config.dart';
import '/models/failure.dart';
import '../../models/audio_file.dart';
import 'base_audios_repo.dart';

class AudiosRepository extends BaseAudiosRepository {
  @override
  Future<void> addAudio(AudioFile audio) async {
    try {
      await HiveConfig().addAudios(audio);
    } on HiveError catch (error) {
      print('Error in deleting note ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in deleting note ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  @override
  Future<void> deleteAudio(String id) async {
    try {
      await HiveConfig().deleteAudio(id);
    } on HiveError catch (error) {
      print('Error in deleting note ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in deleting note ${error.toString}');
      throw Failure(message: error.toString());
    }
  }

  @override
  List<AudioFile> getAudios() {
    try {
      return HiveConfig().getAudios();
    } on HiveError catch (error) {
      print('Error in deleting note ${error.message}');
      throw Failure(message: error.message);
    } catch (error) {
      print('Error in deleting note ${error.toString}');
      throw Failure(message: error.toString());
    }
  }
}
