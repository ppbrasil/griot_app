class ValidationService {
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    if (!isEmailValid(value)) {
      return 'Please enter a valid email';
    } // Other validation checks...
    return null; // Returns null if the input is valid
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    if (value.length < 8) {
      return 'Passwords must have at least 8 characters';
    }
    return null;
  }

  String? validateMemoryTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title for your memory';
    } else if (value.length < 8) {
      return 'Titles must have at least 8 characters';
    } else if (value.length > 255) {
      return 'Titles can\'t have more then 255 characters';
    }
    return null;
  }
}

bool isEmailValid(String email) {
  final RegExp regex =
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
  return regex.hasMatch(email);
}
