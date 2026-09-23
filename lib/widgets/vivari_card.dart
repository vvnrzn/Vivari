import 'package:flutter/material.dart';

class VivariCard extends StatelessWidget {
  const VivariCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
