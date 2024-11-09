import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps/core/widgets/r_card.dart';

class AppErrorModel {
  const AppErrorModel({
    required this.body,
  });

  final String body;

  void showError() {
    Get.closeAllSnackbars();
    Get.showSnackbar(
      GetSnackBar(
        duration: const Duration(seconds: 5),
        animationDuration: const Duration(milliseconds: 500),
        dismissDirection: DismissDirection.horizontal,
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: Colors.transparent,
        messageText: RCard(
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              body,
              style: Get.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
