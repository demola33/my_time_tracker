import 'package:flutter/foundation.dart';
import 'package:my_time_tracker/app/home/models/job.dart';
import 'package:my_time_tracker/services/api_path.dart';
import 'package:my_time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);

  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase implements Database {
  final String uid;
  final _service = FirestoreService.instance;
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  Future<void> createJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, 'job_002'),
        data: job.toMap(),
      );

  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );
}
