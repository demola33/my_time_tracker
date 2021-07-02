import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:my_time_tracker/app/home/models/entry.dart';
import 'package:my_time_tracker/app/home/models/job.dart';
import 'package:my_time_tracker/blocs/models/custom_user_model.dart';
import 'package:my_time_tracker/services/api_path.dart';
import 'package:my_time_tracker/services/firestore_service.dart';

import 'package:my_time_tracker/blocs/models/user_profile.dart';

abstract class Database {
  Future<void> setJob(Job job);

  Future<void> deleteJob(Job job);

  Stream<List<Job>> jobsStream();

  Future<void> setEntry(Entry entry);

  Future<void> deleteEntry(Entry entry);

  Stream<List<Entry>> entriesStream({Job job});

  //Future writeUserDataToFirestore(CustomUser userProfile);

  Stream<CustomUser> userProfileStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  final String uid;
  final _service = FirestoreService.instance;

  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  //var _userProfileCollection = FirestoreService.userProfileCollection;
  Future<void> writeUserDataToFirestore(CustomUser userProfile) async {
    return await _service.setData(
      path: APIPath.userProfile(uid),
      data: userProfile.toMap(),
    );
  }

  Future<void> updateUserDataOnFirestore(Map<String, dynamic> data) async {
    return await _service.updateData(
      path: APIPath.userProfile(uid),
      data: data,
    );
  }

  @override
  Stream<CustomUser> userProfileStream() {
    return _service.documentStream<CustomUser>(
      path: APIPath.userProfile(uid),
      builder: (data, uid) => CustomUser.fromMap(data, uid),
    );
  }

  @override
  Future<void> setJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Future<void> deleteJob(Job job) async {
    try {
      // delete where entry.jobId == job.jobId
      final allEntries = await entriesStream(job: job).first;
      for (Entry entry in allEntries) {
        if (entry.jobId == job.id) {
          await deleteEntry(entry);
        }
      }
      // delete job
      await _service.deleteData(path: APIPath.job(uid, job.id));
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

  @override
  Stream<List<Job>> jobsStream() {
    return _service.collectionStream(
      path: APIPath.jobs(uid),
      builder: (data, documentId) => Job.fromMap(data, documentId),
    );
  }

  @override
  Future<void> setEntry(Entry entry) async {
    try {
      await _service
          .setData(
        path: APIPath.entry(uid, entry.id),
        data: entry.toMap(),
      )
          .catchError((onError) {
        Future.error(onError);
      });
    } catch (e) {
      print('ERRORRRRRRR SPOTTED : ${e.toString()}');
    }
  }

  @override
  Future<void> deleteEntry(Entry entry) async =>
      await _service.deleteData(path: APIPath.entry(uid, entry.id));

  @override
  Stream<List<Entry>> entriesStream({Job job}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
