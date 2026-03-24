import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class AppErrorHandler {
  static void handleError({
    required BuildContext context,
    required String message,
    Object? error,
    String? name,
  }) {
    // 1. Catat ke Developer Log (Hanya muncul di konsol saat Debug)
    if (kDebugMode) {
      developer.log(message, error: error, name: name ?? 'AppError');
    }

    // 2. Tampilkan SnackBar ke User
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).hideCurrentSnackBar(); // Tutup snackbar lama jika ada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: "OK",
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }
}
