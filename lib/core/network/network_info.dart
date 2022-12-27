import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// return [true] if connection status is connected
///
/// or return [false] if connection status is disconnected
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});

  @override
  Future<bool> get isConnected async {
    if (await connectivity.checkConnectivity() == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}