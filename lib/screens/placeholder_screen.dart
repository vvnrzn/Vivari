import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: Text(title)),
      body: Center(
        child: Text(
          '$title is ready to be built.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
