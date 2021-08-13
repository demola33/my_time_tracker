import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/jobs/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, int index);

const _horizontalPadding = 10.0;

class CustomListBuilder<T> extends StatefulWidget {
  const CustomListBuilder({
    Key key,
    @required this.customList,
    @required this.itemBuilder,
    @required this.scrollBarColor,
  }) : super(key: key);

  final List<T> customList;
  final ItemWidgetBuilder<T> itemBuilder;
  final Color scrollBarColor;

  @override
  _CustomListBuilderState<T> createState() => _CustomListBuilderState<T>();
}

class _CustomListBuilderState<T> extends State<CustomListBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    if (widget.customList.isNotEmpty) {
      final List<T> items = widget.customList;
      return _buildContent(items);
    } else {
      return EmptyContent();
    }
  }

  Widget _buildContent(List<T> items) {
    return Theme(
      data: Theme.of(context).copyWith(
          scrollbarTheme: ScrollbarThemeData(
              thumbColor: MaterialStateProperty.all(widget.scrollBarColor))),
      child: Scrollbar(
        thickness: 10.0,
        radius: Radius.circular(8.0),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
          ),
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: widget.customList.length,
          itemBuilder: (context, index) => Card(
            elevation: 2.0,
            child: widget.itemBuilder(context, index),
          ),
        ),
      ),
    );
  }
}
