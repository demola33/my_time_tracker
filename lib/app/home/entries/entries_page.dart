import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/entries/entries_view_model.dart';
import 'package:my_time_tracker/app/home/job_entries/format.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';
import 'package:provider/provider.dart';
import 'package:my_time_tracker/app/home/entries/entries_list_tile.dart';
import 'package:my_time_tracker/app/home/jobs/list_items_builder.dart';
import 'package:my_time_tracker/services/database.dart';

class EntriesPage extends StatelessWidget {
  final Color uniqueEntriesPageColor = const Color.fromRGBO(0, 88, 72, 0.5);

  const EntriesPage({Key key}) : super(key: key);

  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context);
    return Provider<EntriesViewModel>(
      create: (_) => EntriesViewModel(
        database: database,
        format: Format(),
      ),
      child: const EntriesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.teal),
        backgroundColor: uniqueEntriesPageColor,
        title: Text(
          'Entries',
          style: CustomTextStyles.textStyleTitle(),
        ),
        centerTitle: false,
        elevation: 5.0,
      ),
      body: Container(
        color: uniqueEntriesPageColor.withOpacity(0.1),
        child: _buildContents(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final vm = Provider.of<EntriesViewModel>(context);
    return StreamBuilder<List<EntriesListTileModel>>(
      stream: vm.entriesTileModelStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListItemsBuilder<EntriesListTileModel>(
            scrollBarColor: uniqueEntriesPageColor,
            snapshot: snapshot,
            itemBuilder: (context, model) => EntriesListTile(model: model),
          ),
        );
      },
    );
  }
}
