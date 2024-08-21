import 'package:darts_template_right/core/index.dart';
import 'package:darts_template_right/models/index.dart';

part 'list_state.dart';

class ListCubit<ItemsType, FiltersType>
    extends AsyncCubit<ListState<ItemsType, FiltersType>> {
  FiltersType initialFilters;

  FutureFailable<List<ItemsType>> Function(
    FiltersType,
    PaginationModel,
  ) loadItemsCallback;

  ListCubit({
    required this.initialFilters,
    required this.loadItemsCallback,
  }) : super(
          initialData: ListState(
            pagination: PaginationModel.initial(),
            data: [],
            status: RequestStatus.initial,
            filters: initialFilters,
            isLoadingNewItems: false,
          ),
        );

  void loadItems([bool resetPagination = true]) async {
    if (state.data.isLoadingNewItems ||
        state.data.status == RequestStatus.loading) {
      return;
    }
    emit(
      state.copyWith(
        status: resetPagination ? RequestStatus.loading : null,
        data: state.data.copyWith(
          isLoadingNewItems: !resetPagination,
          pagination: resetPagination
              ? PaginationModel.initial()
              : state.data.pagination.copyWith(
                  offset: state.data.pagination.offset +
                      state.data.pagination.limit,
                ),
        ),
      ),
    );
    final result =
        await loadItemsCallback(state.data.filters, state.data.pagination);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: RequestStatus.error,
            failure: failure,
            data: state.data.copyWith(
              pagination: PaginationModel.initial(),
            ),
          ),
        );
      },
      (resultingList) {
        final newList = List<ItemsType>.from(state.data.data);

        newList.addAll(resultingList);
        emit(
          state.copyWith(
            data: state.data.copyWith(
              pagination: PaginationModel(
                limit: state.data.pagination.limit,
                offset: resultingList.isEmpty
                    ? state.data.pagination.offset - state.data.pagination.limit
                    : state.data.pagination.offset,
              ),
              data: resetPagination ? resultingList : newList,
              isLoadingNewItems: false,
            ),
            status: RequestStatus.success,
          ),
        );
      },
    );
  }

  /// Change filters, based on the previous version of them
  void changeFilters(FiltersType Function(FiltersType) oldToNew) {
    final newFilters = oldToNew.call(
      state.data.filters,
    );

    if (newFilters != state.data.filters) {
      emit(
        state.copyWith(
          data: state.data.copyWith(
            filters: newFilters,
          ),
        ),
      );
      loadItems();
    }
  }
}
