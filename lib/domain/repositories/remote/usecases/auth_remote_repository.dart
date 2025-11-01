abstract class AuthRemoteRepository {
  Future loginClient({
    required String usernameOrEmail,
    required String password,
    required Function({String? accesToken}) loginCallback,
    // String firebaseToken
  });
}
