import 'package:flutter/material.dart';

///
/// GeoFenceFinishedResult
class GeoFenceFinishedResult {
  bool _isAddGeoFenceSuccess;
  num _errorCode;
  String _errorInfo;
  GeoFenceFinishedResult.convertFromNative({
    @required dynamic arguments,
  }) {
    _isAddGeoFenceSuccess = arguments['isAddGeoFenceSuccess'];
    _errorCode = arguments['errorCode'];
    _errorInfo = arguments['errorInfo'];
  }

  bool get isAddGeoFenceSuccess => _isAddGeoFenceSuccess;

  num get errorCode => _errorCode;

  String get errorInfo => _errorInfo;

  @override
  String toString() {
    return """
            GeoFenceFinishedResult{
              _isAddGeoFenceSuccess: $_isAddGeoFenceSuccess
              , _errorCode: $_errorCode
              , _errorInfo: $_errorInfo
            }
      """;
  }
}
