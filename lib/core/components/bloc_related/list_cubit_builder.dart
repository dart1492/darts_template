import 'package:darts_template_right/core/index.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';

import 'async_bloc_builder.dart';

//TODO: ADJUST ACCORDING TO THE SPECIFIC APPS'S DESIGN AND REQUIREMENTS
class ListCubitBuilder<ItemsType, FiltersType> extends StatefulWidget {
  final ListCubit<ItemsType, FiltersType> paginatedListAC;

  final Widget? Function(BuildContext, int, ItemsType) itemBuilder;

  final Widget? errorPlaceholder;
  const ListCubitBuilder({
    super.key,
    required this.paginatedListAC,
    this.errorPlaceholder,
    required this.itemBuilder,
  });

  @override
  State<ListCubitBuilder> createState() =>
      _ListCubitBuilderState<ItemsType, FiltersType>();
}

class _ListCubitBuilderState<ItemsType, FiltersType>
    extends State<ListCubitBuilder<ItemsType, FiltersType>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if (widget.paginatedListAC.state.status == RequestStatus.loading ||
        widget.paginatedListAC.state.status == RequestStatus.success ||
        widget.paginatedListAC.state.status == RequestStatus.error) {
    } else {
      widget.paginatedListAC.loadItems(true);
    }

    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          widget.paginatedListAC.loadItems(false);
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncBlocBuilder<ListState<ItemsType, FiltersType>>(
      cubit: widget.paginatedListAC,
      onError: (failure) {
        return widget.errorPlaceholder ?? const SizedBox();
      },
      onLoading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      onAll: (data, _) {
        return const SizedBox();
      },
      onSuccess: (listState) {
        return RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            widget.paginatedListAC.loadItems();
          },
          child: FadingEdgeScrollView.fromScrollView(
            gradientFractionOnEnd: 0.05,
            gradientFractionOnStart: 0.05,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: listState.data.length + 1,
              separatorBuilder: (context, index) => const SizedBox(
                height: 16,
              ),
              itemBuilder: (BuildContext context, int index) {
                if (index == listState.data.length) {
                  if (listState.isLoadingNewItems) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return const SizedBox(
                      height: 80,
                    );
                  }
                }
                return widget.itemBuilder(
                  context,
                  index,
                  listState.data[index],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
