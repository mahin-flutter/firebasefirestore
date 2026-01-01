import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listapp/models/user_model.dart';

class Firebaseservice {

  final CollectionReference db = FirebaseFirestore.instance.collection('users');
  
  // Display Details as List fromo DB
  Stream<List<UserModel>> getUsers() {
    return db
    .snapshots().map((snapshot){
      return snapshot.docs
      .map((doc) => UserModel.fromDoc(doc.id, doc.data() as Map<String, dynamic>))
      .toList();
    });
  }

  // Add Details
  Future<void> addUser(UserModel user) async{
    await db.add(user.toMap());
  }

  // Edit Details
  Future<void> editUser(UserModel user) async{
    await db.doc(user.id).update(user.toMap());
  }

  // Delete Details
  Future<void> deleteUser(String id) async{
    await db.doc(id).delete();
  }
}