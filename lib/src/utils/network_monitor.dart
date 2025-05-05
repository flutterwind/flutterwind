import 'dart:async';
import 'package:flutter/foundation.dart';

class NetworkRequest {
  final String url;
  final String method;
  final DateTime startTime;
  DateTime? endTime;
  int? statusCode;
  String? error;
  int? responseSize;
  Map<String, String>? headers;

  NetworkRequest({
    required this.url,
    required this.method,
    required this.startTime,
  });

  Duration? get duration {
    if (endTime == null) return null;
    return endTime!.difference(startTime);
  }
}

class NetworkMonitor {
  static final NetworkMonitor _instance = NetworkMonitor._internal();
  factory NetworkMonitor() => _instance;
  NetworkMonitor._internal();

  final _requests = <NetworkRequest>[];
  final _requestsController =
      StreamController<List<NetworkRequest>>.broadcast();

  Stream<List<NetworkRequest>> get requestsStream => _requestsController.stream;
  List<NetworkRequest> get requests => List.unmodifiable(_requests);

  void trackRequest(NetworkRequest request) {
    _requests.add(request);
    _requestsController.add(_requests);
  }

  void completeRequest(
    NetworkRequest request, {
    required int statusCode,
    required int responseSize,
    required Map<String, String> headers,
  }) {
    request.endTime = DateTime.now();
    request.statusCode = statusCode;
    request.responseSize = responseSize;
    request.headers = headers;
    _requestsController.add(_requests);
  }

  void addError(NetworkRequest request, String error) {
    request.error = error;
    request.endTime = DateTime.now();
    _requestsController.add(_requests);
  }

  void clear() {
    _requests.clear();
    _requestsController.add(_requests);
  }
}
