import 'package:flutter/material.dart';

class SizedContainer extends StatelessWidget {
  final Widget child;
  const SizedContainer(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      height: 150.0,
      child: Center(child: child),
    );
  }
}
