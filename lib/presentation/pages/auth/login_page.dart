import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:invoice_list_test/config/constants/consts.dart';
import 'package:invoice_list_test/config/constants/errors.dart';
import 'package:invoice_list_test/config/helpers/snackbar_gi.dart';
import 'package:invoice_list_test/config/helpers/utils.dart';
import 'package:invoice_list_test/config/router/router_path.dart';
import 'package:invoice_list_test/data/shared_preferences/constants_shared_prefs.dart';
import 'package:invoice_list_test/data/shared_preferences/shared_prefs.dart';
import 'package:invoice_list_test/presentation/providers/auth/account_form_login_provider.riverpod.dart';

class LoginPage extends HookConsumerWidget {
  final Debounce _emailDebounce = Debounce(milliseconds: 800);
  LoginPage({super.key});
  @override
  Widget build(BuildContext context, ref) {
    final loginProvider = ref.watch(loginFromAccountProvider);
    final rememberCheck = useState(
      (Prefs.instance.getValue(ConstantsSharedPrefs.password) != '')
          ? true
          : false,
    );
    Future<void> onSubmit() async {
      final String code = await loading(
        context: context,
        action: ref.read(loginFromAccountProvider.notifier).onSubmit(),
      );
      if (code != ErrorsConsts.ok) {
        switch (code) {
          case ErrorsConsts.expired_token:
            SnackBarGI.showWithIcon(
              context,
              icon: Icons.error_outline,
              text: "Credenciales incorrectas",
            );
            break;
          case ErrorsConsts.invalid_Form:
            SnackBarGI.showWithIcon(
              context,
              icon: Icons.error_outline,
              text: "Formulario inválido",
            );
            break;
          case ErrorsConsts.must_active_the_account:
            SnackBarGI.showWithIcon(
              context,
              icon: Icons.error_outline,
              text: "Debes activar tu cuenta",
            );
            break;
          case ErrorsConsts.not_found:
            SnackBarGI.showWithIcon(
              context,
              icon: Icons.error_outline,
              text: "Usuario no encontrado",
            );
            break;
          default:
            SnackBarGI.showWithIcon(
              context,
              icon: Icons.error_outline,
              text: code.isEmpty ? code : "Error al enviar",
            );
        }
      } else {
        context.go(RouterPath.HomePage);
        Prefs.instance.saveValue(
          ConstantsSharedPrefs.mark,
          ApkConstants.isLogged,
        );
        if (rememberCheck.value) {
          Prefs.instance.saveValue(
            ConstantsSharedPrefs.email,
            loginProvider.usernameOrEmail.value,
          );
          Prefs.instance.saveValue(
            ConstantsSharedPrefs.password,
            loginProvider.password.value,
          );
        }
      }
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      "Iniciar sesión",
                      style: Theme.of(context).textTheme.displayMedium!,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Ingrese su correo y contraseña para iniciar sesión",
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue:
                              (Prefs.instance.getValue(
                                ConstantsSharedPrefs.email,
                              ) ??
                              loginProvider.usernameOrEmail.value),
                          onChanged: (value) => _emailDebounce.run(
                            () => ref
                                .read(loginFromAccountProvider.notifier)
                                .onUsernameOrEmailChange(value),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            errorText: loginProvider.usernameOrEmail
                                .getErrorMessage(context),
                            label: Text("  Correo"),
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          initialValue:
                              (Prefs.instance.getValue(
                                ConstantsSharedPrefs.password,
                              ) ??
                              loginProvider.password.value),
                          obscureText: ref
                              .watch(loginFromAccountProvider)
                              .isObscure,
                          onChanged: (value) => ref
                              .read(loginFromAccountProvider.notifier)
                              .onPasswordChange(value),
                          decoration: InputDecoration(
                            errorText: loginProvider.password.getErrorMessage(
                              context,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => ref
                                  .read(loginFromAccountProvider.notifier)
                                  .obscureText(),
                              icon:
                                  (ref
                                      .watch(loginFromAccountProvider)
                                      .isObscure)
                                  ? const Icon(Icons.remove_red_eye)
                                  : const Icon(Icons.visibility_off),
                            ),
                            label: Text("Contraseña"),
                          ),
                        ),
                        CheckboxListTile(
                          dense: true,
                          selected: true,
                          contentPadding: const EdgeInsets.all(0),
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: rememberCheck.value,
                          onChanged: (value) => rememberCheck.value = value!,
                          title: Text(
                            "Recordarme",
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FilledButton(
                          onPressed: () async => await onSubmit(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 70,
                              vertical: 4,
                            ),
                            child: Text("Iniciar sesión"),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
