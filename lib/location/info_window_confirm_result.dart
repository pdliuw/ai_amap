import 'package:flutter/material.dart';

///
/// InfoWindowConfirmResult
class InfoWindowConfirmResult {
  String _title;
  String _content;
  double _latitude;
  double _longitude;

  ///
  /// constructor
  InfoWindowConfirmResult.convertFromNative({
    @required dynamic arguments,
  }) {
    _title = arguments['title'];
    _content = arguments['snippet'];
    _latitude = arguments['latitude'];
    _longitude = arguments['longitude'];
  }

  double get latitude => _latitude;
  double get longitude => _longitude;
  String get title => _title;
  String get content => _content;

  @override
  String toString() {
    return """
          GeoFenceReceiveResult{
            title: $title
            , content: $content
            , latitude: $latitude
            , longitude: $longitude
          }
      """;
  }
}
