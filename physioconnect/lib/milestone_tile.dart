import 'package:flutter/material.dart';
import '../milestone.dart';

class MilestoneTile extends StatelessWidget {
  final Milestone milestone;

  const MilestoneTile({super.key, required this.milestone});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: milestone.achieved ? Colors.green[400] : Colors.grey[800],
      child: ListTile(
        leading: Icon(
          milestone.achieved ? Icons.check_circle : Icons.hourglass_empty,
          color: milestone.achieved ? Colors.white : Colors.yellowAccent,
        ),
        title: Text(
          milestone.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
