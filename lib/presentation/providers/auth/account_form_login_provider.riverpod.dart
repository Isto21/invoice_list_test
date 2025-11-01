// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:invoice_list_test/config/constants/errors.dart';
import 'package:invoice_list_test/data/dio/my_dio.dart';
import 'package:invoice_list_test/data/shared_preferences/constants_shared_prefs.dart';
import 'package:invoice_list_test/data/shared_preferences/shared_prefs.dart';
import 'package:invoice_list_test/domain/repositories/inputs/inputs.dart';
import 'package:invoice_list_test/presentation/providers/auth/account_provider.riverpod.dart';

final loginFromAccountProvider =
    StateNotifierProvider.autoDispose<AccountLoginFormNotifier, LoginStatus>((
      ref,
    ) {
      return AccountLoginFormNotifier(ref.read(accountProvider.notifier));
    });

class AccountLoginFormNotifier extends StateNotifier<LoginStatus> {
  final AccountNotifier _accountNotifier;
  AccountLoginFormNotifier(this._accountNotifier)
    : super(
        LoginStatus(
          password:
              (Prefs.instance.getValue(ConstantsSharedPrefs.password) != null &&
                  Prefs.instance.getValue(ConstantsSharedPrefs.password) != '')
              ? Password.dirty(
                  Prefs.instance.getValue(ConstantsSharedPrefs.password),
                )
              : const Password.pure(),
          usernameOrEmail:
              (Prefs.instance.getValue(ConstantsSharedPrefs.email) != null &&
                  Prefs.instance.getValue(ConstantsSharedPrefs.email) != '')
              ? Email.dirty(Prefs.instance.getValue(ConstantsSharedPrefs.email))
              : const Email.pure(),
        ),
      );

  Future<String> onSubmit() async {
    try {
      state = state.copyWith(
        usernameOrEmail: state.usernameOrEmail,
        password: state.password,
        isValid: validate(),
      );

      if (!state.isValid) {
        state = state.copyWith(isValid: false);
        return ErrorsConsts.invalid_Form;
      }
      await _accountNotifier.login(
        usernameOrEmail: state.usernameOrEmail.value,
        password: state.password.value,
      );
      state = state.copyWith(
        usernameOrEmail: const Email.pure(),
        password: const Password.pure(),
      );
      return ErrorsConsts.ok;
    } on CustomDioError catch (e) {
      state = state.copyWith(isValid: false);
      return e.code.toString();
    }
  }

  void onUsernameOrEmailChange(String value) {
    final usernameOrEmail = Email.dirty(value.trim());
    state = state.copyWith(
      usernameOrEmail: usernameOrEmail,
      isValid: validate(),
    );
  }

  void onPasswordChange(String value) {
    final password = Password.dirty(value);
    state = state.copyWith(password: password, isValid: validate());
  }

  void obscureText() {
    state = state.copyWith(isObscure: !state.isObscure);
  }

  bool validate({GeneralInput? usernameOrEmail, Password? password}) =>
      Formz.validate([
        usernameOrEmail ?? state.usernameOrEmail,
        password ?? state.password,
      ]);
}

class LoginStatus {
  bool isValid;
  Email usernameOrEmail;
  Password password;
  bool isObscure;
  LoginStatus({
    this.isValid = false,
    this.isObscure = true,
    this.usernameOrEmail = const Email.pure(),
    this.password = const Password.pure(),
  });

  LoginStatus copyWith({
    bool? isValid,
    Email? usernameOrEmail,
    Password? password,
    bool? isObscure,
  }) {
    return LoginStatus(
      isValid: isValid ?? this.isValid,
      usernameOrEmail: usernameOrEmail ?? this.usernameOrEmail,
      password: password ?? this.password,
      isObscure: isObscure ?? this.isObscure,
    );
  }
}
