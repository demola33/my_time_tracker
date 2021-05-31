import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/job_entries/format.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';
import 'package:provider/provider.dart';
import 'package:my_time_tracker/app/home/entries/entries_bloc.dart';
import 'package:my_time_tracker/app/home/entries/entries_list_tile.dart';
import 'package:my_time_tracker/app/home/jobs/list_items_builder.dart';
import 'package:my_time_tracker/services/database.dart';

class EntriesPage extends StatelessWidget {
  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context);
    return Provider<EntriesBloc>(
      create: (_) => EntriesBloc(
        database: database,
        format: Format(),
      ),
      child: EntriesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.teal),
        backgroundColor: Colors.white,
        title: Text(
          'Entries',
          style: CustomTextStyles.textStyleTitle(color: Colors.teal),
        ),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final bloc = Provider.of<EntriesBloc>(context);
    return StreamBuilder<List<EntriesListTileModel>>(
      stream: bloc.entriesTileModelStream,
      builder: (context, snapshot) {
        return ListItemsBuilder<EntriesListTileModel>(
          snapshot: snapshot,
          itemBuilder: (context, model) => EntriesListTile(model: model),
        );
      },
    );
  }
}
