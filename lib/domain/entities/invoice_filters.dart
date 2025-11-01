import 'package:flutter/widgets.dart';
import 'package:invoice_list_test/domain/entities/invoice_entity.dart';

class InvoiceFilters {
  final String? searchQuery;
  final InvoiceState? state;
  final DateTime? issuedFrom;
  final DateTime? issuedUntil;
  final int page;

  const InvoiceFilters({
    this.searchQuery,
    this.state,
    this.issuedFrom,
    this.issuedUntil,
    this.page = 1,
  });

  Map<String, String> toQueryParameters() {
    final params = <String, String>{};

    if (searchQuery != null && searchQuery!.isNotEmpty) {
      params['q[contact_name_or_number_or_reference_or_description_cont]'] =
          searchQuery!;
    }

    if (state != null) {
      params['q[state_eq]'] = InvoiceStateExtension(state!).name;
    }

    if (issuedFrom != null) {
      params['q[issued_at_gteq]'] = _formatDate(issuedFrom!);
    }

    if (issuedUntil != null) {
      params['q[issued_at_lteq]'] = _formatDate(issuedUntil!);
    }

    params['page'] = page.toString();

    return params;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  InvoiceFilters copyWith({
    ValueGetter<String?>? searchQuery,
    ValueGetter<InvoiceState?>? state,
    ValueGetter<DateTime?>? issuedFrom,
    ValueGetter<DateTime?>? issuedUntil,
    int? page,
  }) {
    return InvoiceFilters(
      searchQuery: searchQuery != null ? searchQuery() : this.searchQuery,
      state: state != null ? state() : this.state,
      issuedFrom: issuedFrom != null ? issuedFrom() : this.issuedFrom,
      issuedUntil: issuedUntil != null ? issuedUntil() : this.issuedUntil,
      page: page ?? this.page,
    );
  }
}
