import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  ConnectivityProvider() {
    _subscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _initConnectivity();
  }

  ConnectivityResult get connectionStatus => _connectionStatus;

  Future<void> _initConnectivity() async {
    List<ConnectivityResult> statuses;
    try {
      statuses = await _connectivity.checkConnectivity();
    } catch (e) {
      statuses = [ConnectivityResult.none];
    }
    _updateConnectionStatus(statuses);
  }

  void _updateConnectionStatus(List<ConnectivityResult> statuses) {
    if (statuses.isNotEmpty) {
      _connectionStatus = statuses.first;
    } else {
      _connectionStatus = ConnectivityResult.none;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
