import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:genius_ai/utils/app_snackbar.dart';

/// Returns true when a network interface is available.
///
/// Pass [showError] to surface a toast when offline.
Future<bool> has_internet({bool show_error = false}) async {
  final connectivity_results = await Connectivity().checkConnectivity();

  if (connectivity_results.contains(ConnectivityResult.none)) {
    if (show_error) {
      AppSnackbar.show(
        message:
            "Failed to establish connection, please check your internet connection.",
      );
    }
    return false;
  }

  return true;
}
