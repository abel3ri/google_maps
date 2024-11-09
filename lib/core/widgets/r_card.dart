import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RCard extends StatelessWidget {
  const RCard({
    super.key,
    required this.child,
    this.color,
    this.gradient = false,
  });

  final Widget child;
  final Color? color;
  final bool gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Get.isDarkMode ? Colors.black26 : Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: gradient
            ? const LinearGradient(
                colors: [
                  Color.fromARGB(255, 231, 135, 10),
                  Colors.deepOrangeAccent,
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              )
            : null,
      ),
      child: child,
    );
  }
}
