import 'package:empty_widget/empty_widget.dart';

import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/jobs/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

const _horizontalPadding = 10.0;

class ListItemsBuilder<T> extends StatefulWidget {
  const ListItemsBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
    @required this.scrollBarColor,
  }) : super(key: key);

  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final Color scrollBarColor;

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
        return const EmptyContent();
      }
    } else if (widget.snapshot.hasError) {
      return const EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
        packageImage: PackageImage.Image_4,
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildContent(List<T> items) {
    return Theme(
      data: Theme.of(context).copyWith(
          scrollbarTheme: ScrollbarThemeData(
              thumbColor: MaterialStateProperty.all(widget.scrollBarColor))),
      child: Scrollbar(
        thickness: 10.0,
        radius: const Radius.circular(8.0),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
          ),
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: items.length,
          itemBuilder: (context, index) => Card(
            elevation: 2.0,
            child: widget.itemBuilder(context, items[index]),
          ),
        ),
      ),
    );
  }
}
