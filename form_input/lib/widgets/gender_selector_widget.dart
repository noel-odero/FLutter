import 'package:flutter/material.dart';
import 'form_field_label.dart';

class GenderSelectorWidget extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String?> onChanged;

  const GenderSelectorWidget({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(label: 'Sex'),
        SizedBox(width: 30),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTile<String>(
                title: Text('Male', style: TextStyle(fontSize: 18)),
                groupValue: selectedGender,
                onChanged: onChanged,
                contentPadding: EdgeInsets.zero,
                value: 'Male',
              ),
              RadioListTile<String>(
                title: Text('Female', style: TextStyle(fontSize: 18)),
                groupValue: selectedGender,
                onChanged: onChanged,
                contentPadding: EdgeInsets.zero,
                value: 'Female',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
