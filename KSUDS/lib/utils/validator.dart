class FieldValidator {
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please Enter email address';
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Invalid Email';
    }
    if (value.contains(" ")) {
      return 'Invalid Email';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) return 'Please enter password';
    if (value.length < 6) {
      return "Enter a combination of at least 6 numbers, \nalphabets & special characters";
    }
    if (!RegExp(r"^(?=.*?[0-9])").hasMatch(value)) {
      return 'Enter a combination of at least 6 numbers, \nalphabets & special characters';
    }
    if (!RegExp(r'^(?=.*?[!@#\$&*~])').hasMatch(value.trim())) {
      return 'Enter a combination of at least 6 numbers, \nalphabets & special characters';
    }
    return null;
  }

  static String? validatePasswordMatch(String value, String pass2) {
    if (value.isEmpty) return "Confirm password is required";
    if (value != pass2) {
      return 'Password didn\'t match';
    }
    return null;
  }

  static String? validateName(String value) {
    if (value.isEmpty) {
      return 'Please enter your full name';
    }

    if (!RegExp(r"^[A-Z a-z]{2,25}$").hasMatch(value)) {
      return 'Incorrect full name';
    }

    return null;
  }

  static String? checkEmpty(String value) {
    if (value.isEmpty) {
      return 'required field';
    }

    return null;
  }

  static String? validateConfirmPassword(String value) {
    if (value.isEmpty) return "Confirm password is required";
    if (value.length < 6) {
      return "Enter a combination of at least 6 numbers, \nalphabets & special characters";
    }
    if (!RegExp(r"^(?=.*?[0-9])").hasMatch(value)) {
      return 'Enter a combination of at least 6 numbers, \nalphabets & special characters';
    }
    if (!RegExp(r'^(?=.*?[!@#\$&*~])').hasMatch(value.trim())) {
      return 'Enter a combination of at least 6 numbers, \nalphabets & special characters';
    }
    return null;
  }

  static String? validatePhoneNumber(String value) {
    print("validatepassword : $value ");

    if (value.isEmpty) return "Please enter your phone number";
    if (value.length <= 8) {
      return "Invalid number";
    }

    String pattern = r'(^(?:[+0]9)?[0-9]{9,15}$)';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return "Invalid Number";
    }
    return null;
  }
}
