import 'package:flutter/material.dart';
import 'form_field_label.dart';

class UsernameFieldWidget extends StatelessWidget {
  final TextEditingController controller;

  const UsernameFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FormFieldLabel(label: 'Username'),
        SizedBox(width: 30),
        Expanded(
          child: TextFormField(
            maxLength: 20,
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter your username',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
