import 'package:flutter/material.dart';

class KDetailRow extends StatelessWidget {
  const KDetailRow({super.key, required this.heading, required this.value});
  final String heading;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '$heading:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12)
    ]);
  }
}
