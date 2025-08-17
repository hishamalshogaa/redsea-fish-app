import 'package:flutter/material.dart';

class SatelliteToggle extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;
  const SatelliteToggle({super.key, required this.enabled, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('صورة قمر صناعي'),
        Switch(value: enabled, onChanged: onChanged),
      ],
    );
  }
}
