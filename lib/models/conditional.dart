
import 'package:flutter/material.dart';

class ConditionalWidget extends StatelessWidget {
  final bool condition;
  final Widget? child;
  final Widget? fallback;

  const ConditionalWidget({
    super.key,
    required this.condition,
    this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return condition ? child! : fallback!;
  }
}
