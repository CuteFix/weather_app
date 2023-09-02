import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  final VoidCallback refresh;
  const RefreshButton({super.key, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        refresh();
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
          size: 30.0,
        ),
      ),
    );
  }
}
