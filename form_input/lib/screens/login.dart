import 'package:flutter/material.dart';
import '../models/login_form_model.dart';
import '../widgets/username_field_widget.dart';
import '../widgets/password_field_widget.dart';
import '../widgets/gender_selector_widget.dart';
import '../widgets/course_selector_widget.dart';
import '../widgets/tuition_slider_widget.dart';
import '../widgets/form_action_buttons.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Form data model
  late LoginFormModel formModel;

  // UI state
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    formModel = LoginFormModel.initial();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _updateGender(String? value) {
    setState(() {
      formModel.selectedGender = value;
    });
  }

  void _updateCourses(Map<String, bool> courses) {
    setState(() {
      formModel.courses = courses;
    });
  }

  void _updateTuition(double value) {
    setState(() {
      formModel.tuitionValue = value;
    });
  }

  void _handleSubmit() {
    formModel.username = usernameController.text;
    formModel.password = passwordController.text;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Submitted successful 😁😁😁'),
        backgroundColor: Colors.black87,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleClear() {
    setState(() {
      usernameController.clear();
      passwordController.clear();
      formModel.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                SizedBox(height: 20),

                // Username Field
                UsernameFieldWidget(controller: usernameController),
                SizedBox(height: 20),

                // Password Field
                PasswordFieldWidget(
                  controller: passwordController,
                  obscureText: _obscureText,
                  onToggleVisibility: _togglePasswordVisibility,
                ),
                SizedBox(height: 20),

                // Gender Selector
                GenderSelectorWidget(
                  selectedGender: formModel.selectedGender,
                  onChanged: _updateGender,
                ),
                SizedBox(height: 20),

                // Course Selector
                CourseSelectorWidget(
                  courses: formModel.courses,
                  onChanged: _updateCourses,
                ),
                SizedBox(height: 20),

                // Tuition Slider
                TuitionSliderWidget(
                  value: formModel.tuitionValue,
                  onChanged: _updateTuition,
                ),
                SizedBox(height: 30),

                // Action Buttons
                FormActionButtons(
                  onSubmit: _handleSubmit,
                  onClear: _handleClear,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.grey[500],
      toolbarHeight: 100.0,
      title: Text(
        'Welcome Back!!!',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
      ),
      centerTitle: true,
    );
  }
}
