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
    try {
      final reference = FirebaseFirestore.instance.doc(path);
      await reference.set(data);
    } catch (e) {
      if (e.message.contains('com.google.firebase.FirebaseException')) {
        throw PlatformException(
          code: 'no-network',
          message:
              'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',
        );
      } else {
        throw PlatformException(
          code: e.code,
          message: e.message,
        );
      }
    }
  }

  Future<void> updateData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    try {
      final reference = FirebaseFirestore.instance.doc(path);
      await reference.update(data);
    } catch (e) {
      if (e.message.contains('com.google.firebase.FirebaseException')) {
        throw PlatformException(
          code: 'no-network',
          message:
              'You are not connected to the internet. Make sure your Wi-fi/Mobile Data is connected to the internet and try again.',
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
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    T Function(Map<String, dynamic> data, String documentID) builder,
    Query Function(Query query) queryBuilder,
    int Function(T lhs, T rhs) sort,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

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
  }

  Future<List<T>> collectionList<T>({
    @required String path,
    T Function(Map<String, dynamic> data, String documentID) builder,
    Query Function(Query query) queryBuilder,
    int Function(T lhs, T rhs) sort,
  }) async {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final QuerySnapshot data = await query.get();
    var docSnapshot = data.docs;
    final result = docSnapshot
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .where((value) => value != null)
        .toList();
    if (sort != null) {
      result.sort(sort);
    }
    return result;
  }

  Stream<T> documentStream<T>({
    @required String path,
    T Function(Map<String, dynamic> data, String documentID) builder,
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }
}
