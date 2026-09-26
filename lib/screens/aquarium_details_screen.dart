import 'package:flutter/material.dart';

import '../models/aquarium.dart';

class AquariumDetailsScreen extends StatelessWidget {
  const AquariumDetailsScreen({required this.aquarium, super.key});

  final Aquarium aquarium;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '${aquarium.name} details are ready to be built.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
