// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_list_test/config/constants/consts.dart';
import 'package:invoice_list_test/config/constants/errors.dart';
import 'package:invoice_list_test/config/router/router.dart';
import 'package:invoice_list_test/config/router/router_path.dart';
import 'package:invoice_list_test/data/dio/my_dio.dart';
import 'package:invoice_list_test/data/shared_preferences/constants_shared_prefs.dart';
import 'package:invoice_list_test/data/shared_preferences/shared_prefs.dart';
import 'package:invoice_list_test/domain/repositories/remote/usecases/auth_remote_repository.dart';
import 'package:invoice_list_test/presentation/providers/data/api_provider.riverpod.dart';

final accountProvider = StateNotifierProvider<AccountNotifier, AccountStatus>((
  ref,
) {
  final account = ref.read(apiProvider).auth;
  final router = ref.read(routerProvider);
  return AccountNotifier(
    router: router,
    accountRemoteRepository: account,
    ref: ref,
  );
});

class AccountNotifier extends StateNotifier<AccountStatus> {
  AuthRemoteRepository accountRemoteRepository;
  Ref ref;
  GoRouter router;
  AccountNotifier({
    required this.accountRemoteRepository,
    required this.ref,
    required this.router,
  }) : super(AccountStatus());

  Future<void> logout() async {
    try {
      Prefs.instance.saveValue(
        ConstantsSharedPrefs.mark,
        ApkConstants.isNotLogged,
      );
      Prefs.instance.saveValue(ConstantsSharedPrefs.accessToken, '');
      router.go(RouterPath.LoginPage);
    } on CustomDioError catch (e) {
      throw e.data["message"].toString();
    }
  }

  Future<String> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      await accountRemoteRepository.loginClient(
        usernameOrEmail: usernameOrEmail,
        password: password,
        loginCallback: ({String? accesToken}) {
          Prefs.instance.saveValue(
            ConstantsSharedPrefs.accessToken,
            accesToken,
          );
        },
      );
      return ErrorsConsts.ok;
    } on CustomDioError catch (_) {
      rethrow;
    }
  }
}

class AccountStatus {
  bool isValid;
  bool isVerifyToken;
  AccountStatus({this.isValid = false, this.isVerifyToken = false});

  AccountStatus copyWith({
    bool? isClientUser,
    bool? isValid,
    bool? isVerifyToken,
  }) {
    return AccountStatus(
      isValid: isValid ?? this.isValid,
      isVerifyToken: isVerifyToken ?? this.isVerifyToken,
    );
  }
}
