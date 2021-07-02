import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/jobs/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

const _horizontalPadding = 10.0;

class ListItemsBuilder<T> extends StatefulWidget {
  const ListItemsBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
  }) : super(key: key);

  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  _ListItemsBuilderState<T> createState() => _ListItemsBuilderState<T>();
}

class _ListItemsBuilderState<T> extends State<ListItemsBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    if (widget.snapshot.hasData) {
      final List<T> items = widget.snapshot.data;
      if (items.isNotEmpty) {
        return _buildContent(items);
      } else {
        return EmptyContent();
      }
    } else if (widget.snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildContent(List<T> items) {
    return Scrollbar(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
        ),
        physics: const ClampingScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) => Card(
          elevation: 2.0,
          child: widget.itemBuilder(context, items[index]),
        ),
      ),
    );
  }
}
