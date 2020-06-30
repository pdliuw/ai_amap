import 'package:flutter/material.dart';

///
/// AiAMapPlatformWidget
// ignore: must_be_immutable
class AiAMapPlatformWidget extends StatefulWidget {
  ///
  static const String UNSUPPORTED_DESCRIPTION_DEFAULT = "Unsupported platform";
  String _unsupportedDescription;

  ///
  /// constructor
  AiAMapPlatformWidget({
    String unsupportedDescription = UNSUPPORTED_DESCRIPTION_DEFAULT,
  }) {
    _unsupportedDescription =
        unsupportedDescription ?? UNSUPPORTED_DESCRIPTION_DEFAULT;
  }

  @override
  State<StatefulWidget> createState() {
    return _AiAMapPlatformState(
        unsupportedDescription: _unsupportedDescription);
  }
}

///
/// _AiAMapPlatformState
class _AiAMapPlatformState extends State<AiAMapPlatformWidget> {
  static const String _viewTypeId = "view_type_id_map_platform_view";
  String _unsupportedDescription;

  ///
  /// constructor
  _AiAMapPlatformState({
    @required String unsupportedDescription,
  }) {
    //values
    _unsupportedDescription = unsupportedDescription;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _getPlatformView()),
      ],
    );
  }

  Widget _getPlatformView() {
    var platform = Theme.of(context).platform;

    if (platform == TargetPlatform.android) {
      return AndroidView(
        viewType: _viewTypeId,
        onPlatformViewCreated: (int id) {
          //created callback
        },
      );
    } else if (platform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: _viewTypeId,
        onPlatformViewCreated: (int id) {
          //created callback
        },
      );
    } else {
      return Text(_unsupportedDescription);
    }
  }
}
