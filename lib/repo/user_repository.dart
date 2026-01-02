import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:listapp/models/user_model.dart';
import 'package:listapp/services/firebase_service.dart';
import 'package:listapp/services/local_db_service.dart';
import 'package:uuid/uuid.dart';

class UserRepository {

  final _local = LocalDbService();
  final _remote = Firebaseservice();
  final _uuid = Uuid();

  // to display users
  Future<List<UserModel>> getUser() async{
    await pullFromFirebaseIfOnline();
    return _local.getUser();
  }

  //to add or update user
  Future<void> addOrUpdateUser(UserModel user) async{
    final newUser = user.copyWith(
      id: user.id.isEmpty ? _uuid.v4() : user.id,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      isDeleted: 0,
      isSynced: 0
    );

    await _local.userInsertOrUpdate(newUser);
    syncIfOnline();
  }

  Future<void> deleteUser(String id) async{
    await _local.deleteUser(id);
    final connection = await Connectivity().checkConnectivity();
    if(connection != ConnectivityResult.none){
      await _remote.deleteUser(id);
    }
  }

  Future<void> syncIfOnline() async{
    final connection = await Connectivity().checkConnectivity();
    if(connection == ConnectivityResult.none) return;

    //push sqlLite -> firebase
    final unSynced = await _local.getUnsyncedUser();
    for(final user in unSynced){
      if(user.isDeleted == 1){
        await _remote.deleteUser(user.id);
      }else{
        await _remote.uploadUser(user);
      }
      await _local.userInsertOrUpdate(user.copyWith(isSynced: 1));
    }

  }
  Future<void> pullFromFirebaseIfOnline() async {
  final connection = await Connectivity().checkConnectivity();
  if (connection == ConnectivityResult.none) return;

  final remoteUsers = await _remote.fetchUser();
  final localUsers = await _local.getUser();

  for (final remote in remoteUsers) {
    final index = localUsers.indexWhere((l) => l.id == remote.id);

    if (index == -1) {
      await _local.userInsertOrUpdate(
        remote.copyWith(isSynced: 1, isDeleted: 0),
      );
    } else {
      final local = localUsers[index];
      if (remote.updatedAt > local.updatedAt) {
        await _local.userInsertOrUpdate(
          remote.copyWith(isSynced: 1),
        );
      }
    }
  }
}

}