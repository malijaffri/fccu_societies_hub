String? Function(String?) emailValidator({bool checkFormat = false}) => (value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your email.';
  }

  if (checkFormat) {
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value.trim())) {
      return 'Please enter a valid email.';
    }
  }

  return null;
};

String? Function(String?) passwordValidator({bool checkFormat = false}) => (value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password.';
  }

  if (checkFormat) {
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
  }

  return null;
};
