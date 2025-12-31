import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  static final ConnectivityHelper _instance = ConnectivityHelper._internal();

  factory ConnectivityHelper() => _instance;

  ConnectivityHelper._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  Stream<bool> get connectivityStream => _controller.stream;

  void initialize() {
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult>? result,
    ) {
      _controller.add(result?.first != ConnectivityResult.none);
    });
  }

  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result.first != ConnectivityResult.none;
  }

  void dispose() {
    _controller.close();
  }
}
