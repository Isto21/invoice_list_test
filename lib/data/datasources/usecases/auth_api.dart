import 'dart:developer';

import 'package:invoice_list_test/data/dio/my_dio.dart';
import 'package:invoice_list_test/domain/repositories/remote/usecases/auth_remote_repository.dart';

class AuthApi extends AuthRemoteRepository {
  final MyDio _myDio;

  AuthApi(this._myDio);

  final String path = "/auth";

  @override
  Future loginClient({
    required String usernameOrEmail,
    required String password,
    required Function({String? accesToken}) loginCallback,
  }) async {
    try {
      final json = await _myDio.request(
        requestType: RequestType.POST,
        path: 'signin',
        data: {
          "sign_in": {
            "email": usernameOrEmail,
            "password": password,
            // "fire_base_token": firebaseToken,
          },
        },
      );
      final String? accesToken = json["token"];
      // final String? refresherToken = json["refresh_token"];

      if (accesToken != null) {
        _myDio.updateToken(accesToken);
        log(accesToken);
      }
      loginCallback(accesToken: accesToken);
    } on CustomDioError catch (_) {
      rethrow;
    } catch (e) {
      throw CustomDioError(code: 400);
    }
  }
}
