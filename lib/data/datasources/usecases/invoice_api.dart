import 'package:invoice_list_test/config/helpers/paginated_response.dart';
import 'package:invoice_list_test/data/datasources/mappers/mappers.dart';
import 'package:invoice_list_test/data/datasources/models/models.dart';
import 'package:invoice_list_test/data/dio/my_dio.dart';
import 'package:invoice_list_test/domain/entities/invoice_entity.dart';
import 'package:invoice_list_test/domain/entities/invoice_filters.dart';
import 'package:invoice_list_test/domain/repositories/remote/usecases/invoice_remote_repository.dart';

class InvoiceApi extends InvoiceRemoteRepository {
  final MyDio _myDio;

  InvoiceApi(this._myDio);
  @override
  Future<PagedResponse<InvoiceEntity>> invoices(InvoiceFilters filters) async {
    try {
      final json = await _myDio.request(
        requestType: RequestType.GET,
        queryParameters: filters.toQueryParameters(),
        path: 'invoices',
      );
      final metadata = PaginationMetadata.fromJson(json['metadata']);
      final List<InvoiceModel> invoices = (json['invoices'] as List)
          .map((item) => InvoiceModel.fromMap(item))
          .toList();

      final List<InvoiceEntity> invoiceEntities = Mappers().invoiceDtoToEntity(
        invoices,
      );

      return PagedResponse(items: invoiceEntities, metadata: metadata);
    } on CustomDioError catch (_) {
      rethrow;
    }
  }
}
