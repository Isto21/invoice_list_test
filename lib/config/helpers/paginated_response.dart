class PagedResponse<T> {
  final List<T> items;
  final PaginationMetadata metadata;

  PagedResponse({required this.items, required this.metadata});

  bool get hasNextPage => metadata.next != null;
  bool get hasPrevPage => metadata.prev != null;
}

class PaginationMetadata {
  final int page;
  final int count;
  final int pages;
  final int? prev;
  final int? next;

  const PaginationMetadata({
    required this.page,
    required this.count,
    required this.pages,
    this.prev,
    this.next,
  });

  factory PaginationMetadata.fromJson(Map<String, dynamic> json) {
    return PaginationMetadata(
      page: json['page'] as int,
      count: json['count'] as int,
      pages: json['pages'] as int,
      prev: json['prev'] as int?,
      next: json['next'] as int?,
    );
  }

  @override
  List<Object?> get props => [page, count, pages, prev, next];
}
