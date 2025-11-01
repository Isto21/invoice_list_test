// Define input validation errors

import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

enum AliasError { empty, format, size }

// Extend FormzInput and provide the input type and error type.
class Username extends FormzInput<String, AliasError> {
  // static final RegExp userNameRegExp = RegExp(r'^[a-zA-Z0-9]+$');
  static final RegExp userNameRegExp = RegExp(r'^[\w\._]+$');
  // Call super.pure to represent an unmodified form input.
  const Username.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Username.dirty(super.value) : super.dirty();

  String? getErrorMessage(BuildContext context) {
    if (isValid || isPure) return null;

    if (displayError == AliasError.empty) {
      return "El campo es requerido";
    }
    if (displayError == AliasError.format) {
      return "Nombre inválido";
    }
    if (displayError == AliasError.size) {
      return "El campo debe tener al menos 2 letras";
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  AliasError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return AliasError.empty;
    if (value.length < 3) return AliasError.size;
    if (!userNameRegExp.hasMatch(value)) return AliasError.format;

    return null;
  }
}
