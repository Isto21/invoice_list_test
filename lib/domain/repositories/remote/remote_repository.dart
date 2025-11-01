import 'package:invoice_list_test/domain/repositories/remote/usecases/auth_remote_repository.dart';
import 'package:invoice_list_test/domain/repositories/remote/usecases/invoice_remote_repository.dart';

abstract class RemoteRepository {
  AuthRemoteRepository get auth;
  InvoiceRemoteRepository get invoice;
}
