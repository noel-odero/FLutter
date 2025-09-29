import 'package:flutter/material.dart';
import 'form_field_label.dart';

// Presenter widget for Course selection
class CourseSelectorWidget extends StatelessWidget {
  final Map<String, bool> courses;
  final ValueChanged<Map<String, bool>> onChanged;

  const CourseSelectorWidget({
    super.key,
    required this.courses,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(label: 'Courses'),
        SizedBox(width: 30),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: courses.keys.map((course) {
              return CheckboxListTile(
                title: Text(course),
                value: courses[course],
                onChanged: (value) {
                  final updatedCourses = Map<String, bool>.from(courses);
                  updatedCourses[course] = value ?? false;
                  onChanged(updatedCourses);
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
