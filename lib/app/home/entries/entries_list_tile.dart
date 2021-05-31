import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';

class EntriesListTileModel {
  const EntriesListTileModel({
    @required this.leadingText,
    @required this.trailingText,
    this.middleText,
    this.isHeader = false,
    this.isMainHeader = false,
  });
  final String leadingText;
  final String trailingText;
  final String middleText;
  final bool isHeader;
  final bool isMainHeader;
}

class EntriesListTile extends StatelessWidget {
  const EntriesListTile({@required this.model});
  final EntriesListTileModel model;

  @override
  Widget build(BuildContext context) {
    const fontSize = 16.0;
    return Container(
      color: model.isHeader || model.isMainHeader ? Colors.teal[100] : null,
      padding: !model.isHeader
          ? EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0)
          : EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            model.leadingText,
            style: model.isHeader || model.isMainHeader
                ? CustomTextStyles.textStyleHeader(fontSize: 17.0)
                : CustomTextStyles.textStyleBold(fontSize: 15.0),
          ),
          Expanded(child: Container()),
          if (model.middleText != null)
            Text(
              model.middleText,
              style: model.isHeader || model.isMainHeader
                  ? CustomTextStyles.textStyleHeader(
                      fontSize: 17.0, color: Colors.green[700])
                  : CustomTextStyles.textStyleBold(
                      fontSize: 15.0, color: Colors.green[700]),
              //textAlign: TextAlign.right,
            ),
          SizedBox(
            width: 100.0,
            child: Text(
              model.trailingText,
              style: model.isHeader || model.isMainHeader
                  ? CustomTextStyles.textStyleHeader(fontSize: 17.0)
                  : CustomTextStyles.textStyleBold(fontSize: 15.0),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
