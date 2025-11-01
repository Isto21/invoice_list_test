import 'package:invoice_list_test/data/datasources/usecases/auth_api.dart';
import 'package:invoice_list_test/data/datasources/usecases/invoice_api.dart';
import 'package:invoice_list_test/data/dio/my_dio.dart';
import 'package:invoice_list_test/domain/repositories/remote/remote_repository.dart';
import 'package:invoice_list_test/domain/repositories/remote/usecases/auth_remote_repository.dart';
import 'package:invoice_list_test/domain/repositories/remote/usecases/invoice_remote_repository.dart';

class ApiConsumer extends RemoteRepository {
  static RemoteRepository _instace() => ApiConsumer._();
  late MyDio _myDio;
  late AuthApi _authApi;
  late InvoiceApi _invoiceApi;

  static RemoteRepository getInstance() => _instace();

  ApiConsumer._() {
    _myDio = MyDio();
    _authApi = AuthApi(_myDio);
    _invoiceApi = InvoiceApi(_myDio);
  }

  @override
  AuthRemoteRepository get auth => _authApi;
  @override
  InvoiceRemoteRepository get invoice => _invoiceApi;
}
