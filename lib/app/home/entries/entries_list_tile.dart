import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_time_tracker/layout/custom_text_style.dart';

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
    return Container(
      color: model.isHeader || model.isMainHeader ? Colors.teal[100] : null,
      padding: !model.isHeader
          ? EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0)
          : EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: SizedBox(
              width: 120,
              child: Text(
                model.leadingText,
                style: model.isHeader || model.isMainHeader
                    ? CustomTextStyles.textStyleExtraBold(fontSize: 17.0)
                    : CustomTextStyles.textStyleBold(fontSize: 15.0),
              ),
            ),
          ),
          if (model.middleText != null)
            Container(
              child: SizedBox(
                width: 80,
                child: Text(
                  model.middleText,
                  style: model.isHeader || model.isMainHeader
                      ? CustomTextStyles.textStyleHeader(
                          fontSize: 15.0,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w800,
                        )
                      : CustomTextStyles.textStyleBold(
                          fontSize: 15.0,
                          //color: Colors.green[700],
                          fontWeight: FontWeight.w700,
                        ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          SizedBox(
            width: 100.0,
            child: Text(
              model.trailingText,
              style: model.isHeader || model.isMainHeader
                  ? CustomTextStyles.textStyleExtraBold()
                  : CustomTextStyles.textStyleExtraBold(),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
