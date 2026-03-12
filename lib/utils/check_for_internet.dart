// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:genius_ai/utils/app_snackbar.dart';

// Future<bool> has_internet({bool show_error = false}) async {
//   final connectivity_result = await Connectivity().checkConnectivity();

//   if (connectivity_result == ConnectivityResult.none) {
//     if (show_error) {
//       AppSnackbar.show(
//         message:
//             "Unable to connect to the internet. Please check your internet connection.",
//       );
//     }
//     return false;
//   }

//   return true;
// }

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:genius_ai/utils/app_snackbar.dart';

Future<bool> hasInternet({bool showError = false}) async {
  final List<ConnectivityResult> connectivityResult = await Connectivity()
      .checkConnectivity();

  if (connectivityResult.contains(ConnectivityResult.none)) {
    if (showError) _showError();

    return false;
  }

  try {
    final result = await InternetAddress.lookup(
      'google.com',
    ).timeout(const Duration(seconds: 5));

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    if (showError) _showError();

    return false;
  } on TimeoutException catch (_) {
    if (showError) _showError();

    return false;
  }

  if (showError) _showError();

  return false;
}

void _showError() {
  AppSnackbar.show(
    message:
        'Failed to establish connection, please check your internet connection',
    type: SnackType.warning,
  );
}
