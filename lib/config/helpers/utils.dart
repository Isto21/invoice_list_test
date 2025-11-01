import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:invoice_list_test/data/dio/my_dio.dart';

Future loading<T>({
  required BuildContext context,
  required Future action,
}) async {
  try {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(
        child: SizedBox(
          height: 60,
          width: 60,
          child: SpinKitRotatingCircle(color: Colors.white, size: 50.0),
        ),
      ),
    );
    final result = await action;
    return result;
  } on CustomDioError catch (_) {
    rethrow;
  } finally {
    context.pop(context);
  }
}

Future showTransitionDialogue(
  Widget widget,
  BuildContext context, {
  bool? barrierDismissible,
}) async {
  final dialog = await showGeneralDialog(
    barrierDismissible: barrierDismissible ?? true,
    barrierLabel: '',
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (ctx, anim1, anim2) => widget,
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 4 * anim1.value,
        sigmaY: 4 * anim1.value,
      ),
      child: FadeTransition(opacity: anim1, child: child),
    ),
    context: context,
  );
  return dialog;
}

class Debounce {
  final int milliseconds;
  Timer? _timer;

  Debounce({required this.milliseconds});

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

String convertDate(String fechaOriginal) {
  try {
    DateTime fecha = DateTime.parse(fechaOriginal);
    return DateFormat('dd/MM/yyyy').format(fecha);
  } catch (e) {
    return "Fecha inválida";
  }
}
