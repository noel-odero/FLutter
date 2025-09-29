class LoginFormModel {
  String username;
  String password;
  String? selectedGender;
  Map<String, bool> courses;
  double tuitionValue;

  LoginFormModel({
    this.username = '',
    this.password = '',
    this.selectedGender,
    required this.courses,
    this.tuitionValue = 0.0,
  });

  factory LoginFormModel.initial() {
    return LoginFormModel(
      courses: {
        "Machine Learning": false,
        "Full stack": false,
        "Mobile dev": false,
      },
    );
  }

  void reset() {
    username = '';
    password = '';
    selectedGender = null;
    courses.updateAll((key, value) => false);
    tuitionValue = 0.0;
  }

  List<String> getSelectedCourses() {
    return courses.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }
}
