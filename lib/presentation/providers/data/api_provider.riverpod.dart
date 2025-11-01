import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_list_test/data/datasources/api.dart';
import 'package:invoice_list_test/domain/repositories/remote/remote_repository.dart';

final apiProvider = StateProvider<RemoteRepository>((ref) {
  return ApiConsumer.getInstance(
    // language: ref.read(localeProvider).locale.languageCode
  );
});
