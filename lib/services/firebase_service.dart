import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listapp/models/user_model.dart';

class Firebaseservice {

  final CollectionReference db = FirebaseFirestore.instance.collection('users');

  //To Upload User Details
  Future<void> uploadUser(UserModel user) async {
  final data = user.toMap();

  data['id'] = user.id;
  data['updatedAt'] =
      user.updatedAt == 0
          ? DateTime.now().millisecondsSinceEpoch
          : user.updatedAt;

  data['isDeleted'] ??= 0;
  data['isSynced'] ??= 1;

  await db.doc(user.id).set(data, SetOptions(merge: true));
}

  
  // TO Fetch User Details
  Future<List<UserModel>> fetchUser() async{
    final snapshot = await db.get();
    return snapshot.docs.map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>,docId: e.id)).toList();
  }

  // Display User Details as List fromo DB
  Stream<List<UserModel>> getUsers() {
    return db
    .snapshots().map((snapshot){
      return snapshot.docs
      .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
      .toList();
    });
  }

  // Add User Details
  Future<void> addUser(UserModel user) async{
    await db.add(user.toMap());
  }

  // Edit User Details
  Future<void> editUser(UserModel user) async{
    await db.doc(user.id).update(user.toMap());
  }

  // Delete User Details
  Future<void> deleteUser(String id) async{
    await db.doc(id).delete();
  }

  Future<void> normalizeFirebaseUsers() async {
  final snapshot = await db.get();

  for (final doc in snapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;

    await db.doc(doc.id).set({
      'id': data['id'] ?? doc.id,
      'fname': data['fname'] ?? '',
      'lname': data['lname'] ?? '',
      'phonenumber': data['phonenumber'] ?? '',
      'district': data['district'] ?? '',
      'state': data['state'] ?? '',
      'country': data['country'] ?? '',
      'updatedAt':
          data['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch,
      'isDeleted': data['isDeleted'] ?? 0,
      'isSynced': 1,
    }, SetOptions(merge: true));
  }
}

}