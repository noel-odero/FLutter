import 'package:flutter/material.dart';
import 'form_field_label.dart';

// Presenter widget for Tuition slider
class TuitionSliderWidget extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const TuitionSliderWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FormFieldLabel(label: 'Tuition'),
        SizedBox(width: 30),
        Expanded(
          child: Slider(
            value: value,
            min: 0.0,
            max: 100.0,
            // divisions: 100,
            activeColor: Colors.lightGreen,
            inactiveColor: Colors.grey[300],
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
