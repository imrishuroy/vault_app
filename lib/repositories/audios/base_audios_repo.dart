import '../../models/audio_file.dart';

abstract class BaseAudiosRepository {
  List<AudioFile> getAudios();
  Future<void> addAudio(AudioFile audio);
  Future<void> deleteAudio(String id);
}
