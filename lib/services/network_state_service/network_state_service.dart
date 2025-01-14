import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:phan_mem_giao_nhac_viec/core/services/notification_service.dart';

class NetworkStateService {
  final Connectivity _connectivity = Connectivity();

  NetworkStateService() {
    _connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  void updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    // if device was not connected to the cellular or wifi network
    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
        !connectivityResult.contains(ConnectivityResult.wifi)) {
      NotificationService.instance.createNotification(
          title: "No connect to the internet",
          body:
              "Please turn on internet to make the application work perfectly",
          payload: {});
    }
  }
}
