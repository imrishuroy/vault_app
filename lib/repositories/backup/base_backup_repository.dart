abstract class BaseBackupRepository {
  Future<void> backUpImages({required String userId});
  Future<void> backupVideos({required String userId});
  Future<void> backUpAudios({required String userId});
  Future<void> backUpPdfs({required String userId});
  Future<void> backupNotes({required String userId});
  Future<void> backUpCards({required String userId});
  Future<void> backUpBanks({required String userId});
  Future<void> backUpPasswords({required String userId});
}
