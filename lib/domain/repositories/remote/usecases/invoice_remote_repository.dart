import 'package:invoice_list_test/config/helpers/paginated_response.dart';
import 'package:invoice_list_test/domain/entities/entities.dart';
import 'package:invoice_list_test/domain/entities/invoice_filters.dart';

abstract class InvoiceRemoteRepository {
  Future<PagedResponse<InvoiceEntity>> invoices(InvoiceFilters filters);
}
