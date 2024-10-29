import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkHelper {
  // Singleton cho NetworkHelper để dễ dàng quản lý
  static final NetworkHelper _instance = NetworkHelper._internal();
  factory NetworkHelper() => _instance;
  NetworkHelper._internal();

  // Biến để lưu trạng thái kết nối mạng hiện tại
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;
  ConnectivityResult _currentStatus = ConnectivityResult.none;

  // Lấy trạng thái kết nối mạng hiện tại
  Future<bool> isConnected() async {
    ConnectivityResult result = (await _connectivity.checkConnectivity()) as ConnectivityResult;
    return result != ConnectivityResult.none;
  }

  // Theo dõi thay đổi trạng thái kết nối mạng
  void subscribeToNetworkChanges(Function(ConnectivityResult) onStatusChange) {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _currentStatus = result as ConnectivityResult;
      onStatusChange(result as ConnectivityResult);
    }) as StreamSubscription<ConnectivityResult>?;
  }

  // Dừng theo dõi thay đổi trạng thái mạng
  void unsubscribeFromNetworkChanges() {
    _subscription?.cancel();
  }

  // Lấy trạng thái kết nối mạng hiện tại (Wifi, Mobile, hoặc None)
  Future<ConnectivityResult> getCurrentNetworkStatus() async {
    return await _connectivity.checkConnectivity() as ConnectivityResult;
  }

  // Kiểm tra xem có kết nối mạng không
  bool isOnline() {
    return _currentStatus != ConnectivityResult.none;
  }
}
