const emailRegex = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';

const usernameRegex = r'^[a-zA-Z0-9_]{3,20}$';

String? confirmPassValidation(value, comparator) {
  if (value!.isEmpty) {
    return 'Confirm password is required';
  } else if (comparator != value) {
    return 'Passwords dont match';
  }
  return null;
}

String? passwordValidation(value) {
  if (value!.isEmpty) {
    return 'Password is required';
  } else if (value.length < 8) {
    return 'Password is too short';
  }
  return null;
}

String? emailValidation(value) {
  if (value!.isEmpty) {
    return 'E-mail is required';
  } else if (!RegExp(emailRegex).hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}

String? nameValidation(value) {
  if (value!.isEmpty) {
    return 'Name is required';
  } else if (value.length < 4) {
    return 'Name is too short';
  }
  return null;
}
