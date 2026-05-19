String authErrorMessage(Object error) {
  if (error is! Exception) {
    return 'Something went wrong.';
  }

  final text = error.toString();

  if (text.contains('user-not-found')) {
    return 'No user found with this email.';
  }

  if (text.contains('wrong-password')) {
    return 'Incorrect password.';
  }

  if (text.contains('email-already-in-use')) {
    return 'This email is already in use.';
  }

  if (text.contains('invalid-email')) {
    return 'Invalid email address.';
  }

  if (text.contains('weak-password')) {
    return 'Password is too weak.';
  }

  return 'Authentication failed.';
}
