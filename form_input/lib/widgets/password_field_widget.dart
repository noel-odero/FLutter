import 'package:flutter/material.dart';
import 'form_field_label.dart';

class PasswordFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  const PasswordFieldWidget({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FormFieldLabel(label: 'Password'),
        SizedBox(width: 30),
        Expanded(
          child: TextFormField(
            obscureText: obscureText,
            maxLength: 10,
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: onToggleVisibility,
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
