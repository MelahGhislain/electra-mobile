enum PurchaseSortOption { newest, oldest, mostExpensive, cheapest, byName }

extension PurchaseSortOptionLabel on PurchaseSortOption {
  String get label {
    switch (this) {
      case PurchaseSortOption.newest:
        return 'Newest First';
      case PurchaseSortOption.oldest:
        return 'Oldest First';
      case PurchaseSortOption.mostExpensive:
        return 'Most Expensive';
      case PurchaseSortOption.cheapest:
        return 'Cheapest';
      case PurchaseSortOption.byName:
        return 'By Name';
    }
  }
}

class PurchaseFilter {
  final String? searchQuery;
  final String? category; // e.g. "Meat", "Groceries"
  final String? merchant; // normalized merchant name
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final PurchaseSortOption sort;

  const PurchaseFilter({
    this.searchQuery,
    this.category,
    this.merchant,
    this.dateFrom,
    this.dateTo,
    this.sort = PurchaseSortOption.newest,
  });

  bool get hasActiveFilters =>
      category != null ||
      merchant != null ||
      dateFrom != null ||
      dateTo != null ||
      sort != PurchaseSortOption.newest;

  int get activeFilterCount {
    int count = 0;
    if (category != null) count++;
    if (merchant != null) count++;
    if (dateFrom != null || dateTo != null) count++;
    if (sort != PurchaseSortOption.newest) count++;
    return count;
  }

  PurchaseFilter copyWith({
    String? searchQuery,
    String? category,
    String? merchant,
    DateTime? dateFrom,
    DateTime? dateTo,
    PurchaseSortOption? sort,
    bool clearSearch = false,
    bool clearCategory = false,
    bool clearMerchant = false,
    bool clearDate = false,
  }) {
    return PurchaseFilter(
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      category: clearCategory ? null : (category ?? this.category),
      merchant: clearMerchant ? null : (merchant ?? this.merchant),
      dateFrom: clearDate ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDate ? null : (dateTo ?? this.dateTo),
      sort: sort ?? this.sort,
    );
  }

  PurchaseFilter reset() => const PurchaseFilter();
}
