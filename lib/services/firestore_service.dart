import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    try{
      final reference = FirebaseFirestore.instance.doc(path);
      await reference.set(data);
    } catch (e){
      if (e.message.contains('com.google.firebase.FirebaseException')){
        throw PlatformException(
          code: 'no-network',
          message: 'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',
        );
      } else {
        throw PlatformException(
          code: e.code,
          message: e.message,
        );
      }
    }
  }

  Future<void> deleteData({@required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  // Stream<List<T>> collectionStream<T>({
  //   @required String path,
  //   @required T builder(Map<String, dynamic> data, String documentId),
  // }) {
  //   final reference = FirebaseFirestore.instance.collection(path);
  //   final snapshots = reference.snapshots();
  //   return snapshots.map((snapshot) => snapshot.docs
  //       .map((snapshot) => builder(snapshot.data(), snapshot.id))
  //       .toList());
  // }
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
   try{
     final Stream<QuerySnapshot> snapshots = query.snapshots();
     return snapshots.map((snapshot) {
       final result = snapshot.docs
           .map((snapshot) => builder(snapshot.data(), snapshot.id))
           .where((value) => value != null)
           .toList();
       if (sort != null) {
         result.sort(sort);
       }
       return result;
     });
   } catch (e){
      print(e.toString());
   }
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }
}
