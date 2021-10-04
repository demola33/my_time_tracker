import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:my_time_tracker/app/home/entries/daily_jobs_details.dart';
import 'package:my_time_tracker/app/home/entries/entries_list_tile.dart';
import 'package:my_time_tracker/app/home/entries/entry_job.dart';
import 'package:my_time_tracker/app/home/job_entries/format.dart';
import 'package:my_time_tracker/app/home/models/entry.dart';
import 'package:my_time_tracker/app/home/models/job.dart';
import 'package:my_time_tracker/services/database.dart';

class EntriesViewModel {
  EntriesViewModel({
    @required this.database,
    @required this.format,
  });
  final Database database;
  final Format format;

  /// combine List<Job>, List<Entry> into List<EntryJob>
  Stream<List<EntryJob>> get _allEntriesStream => Rx.combineLatest2(
        database.entriesStream(),
        database.jobsStream(),
        _entriesJobsCombiner,
      );

  static List<EntryJob> _entriesJobsCombiner(
      List<Entry> entries, List<Job> jobs) {
    return entries.map((entry) {
      final job = jobs.firstWhere((job) => job.id == entry.jobId);
      return EntryJob(entry, job);
    }).toList();
  }

  /// Output stream
  Stream<List<EntriesListTileModel>> get entriesTileModelStream =>
      _allEntriesStream.map(_createModels);

  List<EntriesListTileModel> _createModels(List<EntryJob> allEntries) {
    final allDailyJobsDetails = DailyJobsDetails.all(allEntries);
    if (allEntries.isEmpty) {
      return [];
    }

    // total duration across all jobs
    final totalDuration = allDailyJobsDetails
        .map((dateJobsDuration) => dateJobsDuration.duration)
        .reduce((value, element) => value + element);

    // total pay across all jobs
    final totalPay = allDailyJobsDetails
        .map((dateJobsDuration) => dateJobsDuration.pay)
        .reduce((value, element) => value + element);

    return <EntriesListTileModel>[
      EntriesListTileModel(
          leadingText: 'All Entries',
          middleText: format.currency(totalPay),
          trailingText: format.time(totalDuration),
          isMainHeader: true),
      for (DailyJobsDetails dailyJobsDetails in allDailyJobsDetails) ...[
        EntriesListTileModel(
          isHeader: true,
          leadingText: format.date(dailyJobsDetails.date),
          middleText: format.currency(dailyJobsDetails.pay),
          trailingText: format.time(dailyJobsDetails.duration),
        ),
        for (JobDetails jobDuration in dailyJobsDetails.jobsDetails)
          EntriesListTileModel(
            leadingText: jobDuration.name,
            middleText: format.currency(jobDuration.pay),
            trailingText: format.time(jobDuration.durationInHours),
          ),
      ]
    ];
  }
}
