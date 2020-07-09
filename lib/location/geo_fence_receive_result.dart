import 'package:flutter/material.dart';

///
/// GeoFenceReceiveResult
class GeoFenceReceiveResult {
  num _status;
  String _customId;
  String _fenceId;

  ///
  /// constructor
  GeoFenceReceiveResult.convertFromNative({
    @required dynamic arguments,
  }) {
    _status = arguments['status'];
    _customId = arguments['customId'];
    _fenceId = arguments['fenceId'];
  }

  num get status => _status;
  String get customId => _customId;
  String get fenceId => _fenceId;

  @override
  String toString() {
    return """
          GeoFenceReceiveResult{
            _status: $_status
            , _customId: $_customId
            , _fenceId: $_fenceId
          }
      """;
  }
}
