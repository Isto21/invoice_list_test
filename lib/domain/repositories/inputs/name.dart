// Define input validation errors

import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

enum UserNameError { empty, format, size }

// Extend FormzInput and provide the input type and error type.
class Name extends FormzInput<String, UserNameError> {
  static final RegExp userNameRegExp = RegExp(
    // "^([a-zA-Z]{2,}\s[a-zA-Z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)",
    r'^[A-Za-zÀ-ÖØ-öø-ÿ -]+$',
  );

  // Call super.pure to represent an unmodified form input.
  const Name.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Name.dirty(super.value) : super.dirty();

  String? getErrorMessage(BuildContext context) {
    if (isValid || isPure) return null;

    if (displayError == UserNameError.empty) {
      return "El campo es requerido";
    }
    if (displayError == UserNameError.format) {
      return "Formato incorrecto";
    }
    if (displayError == UserNameError.size) {
      return "Debe tener al menos 2 letras";
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  UserNameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return UserNameError.empty;
    if (value.length < 3) return UserNameError.size;
    if (!userNameRegExp.hasMatch(value)) return UserNameError.format;

    return null;
  }
}
