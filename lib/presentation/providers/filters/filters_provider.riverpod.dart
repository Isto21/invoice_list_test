import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_list_test/domain/entities/invoice_entity.dart';
import 'package:invoice_list_test/domain/entities/invoice_filters.dart';
import 'package:invoice_list_test/presentation/providers/invoice/invoice_provider.riverpod.dart';

class InvoiceFiltersStatus {
  DateTime? issuedFrom;
  DateTime? issuedUntil;
  int? page;
  InvoiceState? invoiceState;
  InvoiceFiltersStatus({
    this.issuedFrom,
    this.issuedUntil,
    this.page = 1,
    this.invoiceState,
  });

  InvoiceFiltersStatus copyWith({
    ValueGetter<DateTime?>? issuedFrom,
    ValueGetter<DateTime?>? issuedUntil,
    ValueGetter<int?>? page,
    ValueGetter<InvoiceState?>? invoiceState,
  }) {
    return InvoiceFiltersStatus(
      issuedFrom: issuedFrom != null ? issuedFrom() : this.issuedFrom,
      issuedUntil: issuedUntil != null ? issuedUntil() : this.issuedUntil,
      page: page != null ? page() : this.page,
      invoiceState: invoiceState != null ? invoiceState() : this.invoiceState,
    );
  }
}

class InvoiceFiltersNotifier extends StateNotifier<InvoiceFiltersStatus> {
  Ref ref;
  InvoiceFiltersNotifier(this.ref) : super(InvoiceFiltersStatus());

  void setIssuedFrom(DateTime? issuedFrom) {
    state = state.copyWith(issuedFrom: () => issuedFrom);
  }

  void setIssuedUntil(DateTime? issuedUntil) {
    state = state.copyWith(issuedUntil: () => issuedUntil);
  }

  void setPage(int page) {
    state = state.copyWith(page: () => page);
  }

  void clearFilters() {
    state = InvoiceFiltersStatus();
  }

  void setState(InvoiceState? invoiceState) {
    state = state.copyWith(invoiceState: () => invoiceState);
  }

  void clearFiltersAndRefresh() {
    clearFilters();
    fetchInvoices();
  }

  void deleteStateFilter() {
    state = state.copyWith(invoiceState: () => null);
    applyFilters();
  }

  void deleteIssuedFromFilter() {
    state = state.copyWith(issuedFrom: () => null);
    applyFilters();
  }

  void deleteIssuedUntilFilter() {
    state = state.copyWith(issuedUntil: () => null);
    applyFilters();
  }

  void deletePageFilter() {
    state = state.copyWith(page: null);
    applyFilters();
  }

  void applyFilters() {
    ref
        .read(invoiceProvider.notifier)
        .updateFilters(
          InvoiceFilters(
            searchQuery: null,
            state: state.invoiceState,
            issuedFrom: state.issuedFrom,
            issuedUntil: state.issuedUntil,
            page: state.page ?? 1,
          ),
        );
  }

  Future<void> fetchInvoices() async {
    state = state.copyWith(page: () => 1);
    await ref.read(invoiceProvider.notifier).fetchInvoices();
  }
}

final invoiceFiltersProvider =
    StateNotifierProvider<InvoiceFiltersNotifier, InvoiceFiltersStatus>((ref) {
      return InvoiceFiltersNotifier(ref);
    });
