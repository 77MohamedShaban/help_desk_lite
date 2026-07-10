class ErrorMessageHandler {
  static String map(dynamic error) {
    final String errorStr = error.toString().toLowerCase();

    if (errorStr.contains('user-not-found') || errorStr.contains('wrong-password') || errorStr.contains('invalid-credential')) {
      return 'Incorrect email or password. Please try again.';
    } else if (errorStr.contains('email-already-in-use')) {
      return 'This email is already registered. Try logging in instead.';
    } else if (errorStr.contains('network-request-failed')) {
      return 'Network error. Please check your internet connection.';
    } else if (errorStr.contains('weak-password')) {
      return 'The password is too weak. Please use a stronger password.';
    } else if (errorStr.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later.';
    } else if (errorStr.contains('invalid-email')) {
      return 'The email address is not valid.';
    } else if (errorStr.contains('permission-denied')) {
      return 'You don\'t have permission to perform this action.';
    }

    return 'Something went wrong. Please try again later.';
  }
}
