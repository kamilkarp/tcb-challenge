import 'package:connectivity_plus/connectivity_plus.dart';

/// Internet access status for the device
enum ConnectivityStatus {
  /// Connected to the Internet
  connected,

  /// Disconnected from the Internet
  disconnected,
}

/// {@template connectivity_repository}
/// Repository providing status of the Internet connection
/// {@endtemplate}
class ConnectivityRepository {
  /// {@macro connectivity_repository}
  ConnectivityRepository({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// Notifies when connection status is changed
  Stream<ConnectivityStatus> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged
        .map(_fromConnectivityResult)
        .asBroadcastStream();
  }

  /// Use to check Internet connection
  Future<ConnectivityStatus> checkConnectivityStatus() async {
    final result = await _connectivity.checkConnectivity();

    return _fromConnectivityResult(result);
  }

  ConnectivityStatus _fromConnectivityResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.ethernet:
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        return ConnectivityStatus.connected;
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.none:
        return ConnectivityStatus.disconnected;
    }
  }
}
