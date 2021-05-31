import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_time_tracker/app/home/job_entries/format.dart';
import 'package:my_time_tracker/app/home/models/entry.dart';
import 'package:my_time_tracker/app/home/models/job.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
import 'package:provider/provider.dart';

class EntryListItem extends StatelessWidget {
  const EntryListItem({
    @required this.entry,
    @required this.job,
  });

  final Entry entry;
  final Job job;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(context),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final format = Provider.of<Format>(context);
    final dayOfWeek = format.dayOfWeek(entry.start);
    final startDate = format.date(entry.start);
    final endDate = format.date(entry.end);
    final startTime = TimeOfDay.fromDateTime(entry.start).format(context);
    final endTime = TimeOfDay.fromDateTime(entry.end).format(context);
    final durationFormatted = format.hours(entry.durationInHours);

    final pay = job.ratePerHour * entry.durationInHours;
    final payFormatted = format.currency(pay);
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(
            dayOfWeek,
            style: CustomTextStyles.textStyleBold(color: Colors.grey),
          ),
          SizedBox(width: size.height * 0.025),
          Text(
            '$startDate - $endDate',
            style: CustomTextStyles.textStyleBold(),
          ),
          if (job.ratePerHour > 0.0) ...<Widget>[
            Expanded(child: Container()),
            Text(
              payFormatted,
              style: CustomTextStyles.textStyleBold(color: Colors.green[700]),
            ),
          ],
        ]),
        Row(children: <Widget>[
          SizedBox(width: size.height * 0.06),
          Text(
            '$startTime - $endTime',
            style: CustomTextStyles.textStyleNormal(color: Colors.black),
          ),
          Expanded(child: Container()),
          Text(
            durationFormatted,
            style: CustomTextStyles.textStyleNormal(color: Colors.black),
          ),
        ]),
        Row(
          children: [
            if (entry.comment.isNotEmpty) ...<Widget>[
              SizedBox(width: size.height * 0.06),
              Card(
                color: Colors.teal,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    entry.comment,
                    style: CustomTextStyles.textStyleNormal(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ]
          ],
        ),
      ],
    );
  }
}

class DismissibleEntryListItem extends StatelessWidget {
  const DismissibleEntryListItem(
      {this.key, this.entry, this.job, this.onDelete, this.onTap, this.onEdit});

  final Key key;
  final Entry entry;
  final Job job;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      key: key,
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: EntryListItem(
          entry: entry,
          job: job,
        ),
      ),
      secondaryActions: [
        IconSlideAction(
          caption: 'Edit',
          color: Colors.black45,
          icon: Icons.edit,
          onTap: () => onEdit,
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => onDelete,
        ),
      ],
    );
  }
}
