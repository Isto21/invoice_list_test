import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_list_test/config/helpers/paginated_response.dart';
import 'package:invoice_list_test/domain/entities/invoice_entity.dart';
import 'package:invoice_list_test/domain/entities/invoice_filters.dart';
import 'package:invoice_list_test/domain/repositories/remote/usecases/invoice_remote_repository.dart';
import 'package:invoice_list_test/presentation/providers/data/api_provider.riverpod.dart';

class InvoiceStatus {
  final PagedResponse<InvoiceEntity>? invoices;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final InvoiceFilters filters;

  const InvoiceStatus({
    this.invoices,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    required this.filters,
  });

  InvoiceStatus copyWith({
    PagedResponse<InvoiceEntity>? invoices,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    InvoiceFilters? filters,
  }) {
    return InvoiceStatus(
      invoices: invoices ?? this.invoices,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      filters: filters ?? this.filters,
    );
  }
}

class InvoiceNotifier extends StateNotifier<InvoiceStatus> {
  final InvoiceRemoteRepository _invoiceRemoteRepository;

  InvoiceNotifier(this._invoiceRemoteRepository)
    : super(InvoiceStatus(filters: const InvoiceFilters()));

  Future<void> fetchInvoices() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _invoiceRemoteRepository.invoices(state.filters);
      state = state.copyWith(invoices: response, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> loadMoreInvoices() async {
    if (state.isLoadingMore ||
        state.invoices == null ||
        !state.invoices!.hasNextPage) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.invoices!.metadata.next!;
      final newFilters = state.filters.copyWith(page: nextPage);
      final response = await _invoiceRemoteRepository.invoices(newFilters);

      final combinedResponse = PagedResponse<InvoiceEntity>(
        items: [...state.invoices!.items, ...response.items],
        metadata: response.metadata,
      );

      state = state.copyWith(invoices: combinedResponse, isLoadingMore: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoadingMore: false);
    }
  }

  void updateFilters(InvoiceFilters newFilters) {
    state = state.copyWith(filters: newFilters);
    fetchInvoices();
  }

  void search(String query) {
    final newFilters = state.filters.copyWith(
      searchQuery: () => query.isEmpty ? null : query,
      page: 1,
    );
    updateFilters(newFilters);
  }

  void filterByState(InvoiceState? stateFilter) {
    final newFilters = state.filters.copyWith(
      state: () => stateFilter,
      page: 1,
    );
    updateFilters(newFilters);
  }

  void filterByDateRange(DateTime? from, DateTime? until) {
    final newFilters = state.filters.copyWith(
      issuedFrom: () => from,
      issuedUntil: () => until,
      page: 1,
    );
    updateFilters(newFilters);
  }

  void goToPage(int page) {
    final newFilters = state.filters.copyWith(page: page);
    updateFilters(newFilters);
  }

  void clearFilters() {
    state = state.copyWith(filters: const InvoiceFilters());
    fetchInvoices();
  }
}

final invoiceProvider = StateNotifierProvider<InvoiceNotifier, InvoiceStatus>(
  (ref) => InvoiceNotifier(ref.read(apiProvider).invoice),
);
