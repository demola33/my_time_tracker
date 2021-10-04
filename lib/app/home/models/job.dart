import 'package:flutter/foundation.dart';

class Job {
  Job({
    @required this.id,
    @required this.name,
    @required this.organization,
    @required this.ratePerHour,
  });

  final String id;
  final String name;
  final String organization;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    final String organization = data['company'];
    return Job(
      id: documentId,
      name: name,
      ratePerHour: ratePerHour,
      organization: organization,
    );
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "ratePerHour": ratePerHour, "company": organization};
  }

  @override
  String toString() {
    return 'Job ID: $id,  Name : $name, Organization: $organization, RPH:$ratePerHour ||';
  }
}
