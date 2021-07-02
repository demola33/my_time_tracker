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
        backgroundColor: Color.fromRGBO(0, 88, 72, 0.5),
        title: Text(
          'Entries',
          style: CustomTextStyles.textStyleTitle(),
        ),
        centerTitle: false,
        elevation: 5.0,
      ),
      body: Container(
        color: Color.fromRGBO(0, 88, 72, 0.1),
        child: _buildContents(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final bloc = Provider.of<EntriesBloc>(context);
    return StreamBuilder<List<EntriesListTileModel>>(
      stream: bloc.entriesTileModelStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListItemsBuilder<EntriesListTileModel>(
            snapshot: snapshot,
            itemBuilder: (context, model) => EntriesListTile(model: model),
          ),
        );
      },
    );
  }
}
