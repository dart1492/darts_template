// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'list_cubit.dart';

class ListState<ItemsType, FiltersType> extends AsyncState<List<ItemsType>> {
  int? totalItemsNumber; //all items number (without pagination)
  FiltersType filters;
  PaginationModel pagination;

  // indicator if it is the first load of the items
  bool isLoadingNewItems;
  ListState({
    required super.data,
    required super.status,
    this.totalItemsNumber,
    required this.filters,
    super.failure,
    required this.pagination,
    required this.isLoadingNewItems,
  });

  @override
  ListState<ItemsType, FiltersType> copyWith({
    List<ItemsType>? data,
    RequestStatus? status,
    Failure? failure,
    int? totalItemsNumber,
    bool? isLoadingNewItems,
    FiltersType? filters,
    PaginationModel? pagination,
  }) {
    return ListState<ItemsType, FiltersType>(
      pagination: pagination ?? this.pagination,
      totalItemsNumber: totalItemsNumber ?? this.totalItemsNumber,
      filters: filters ?? this.filters,
      data: data ?? this.data,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      isLoadingNewItems: isLoadingNewItems ?? this.isLoadingNewItems,
    );
  }

  int get currentPage => this.pagination.offset;
}
