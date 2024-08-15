import 'package:flutter/material.dart';

class CustomAnimations {
  static Animation<Offset> slideFromLeft(AnimationController controller) {
    return Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  static Animation<Offset> slideFromRight(AnimationController controller) {
    return Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  static Animation<Offset> slideUp(AnimationController controller) {
    return Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  static Animation<double> fadeIn(AnimationController controller) {
    return CurvedAnimation(parent: controller, curve: Curves.easeInOut);
  }
}
