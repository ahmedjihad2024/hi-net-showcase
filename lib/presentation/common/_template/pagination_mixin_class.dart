import 'package:hi_net/app/user_messages.dart';
import 'package:hi_net/data/network/error_handler/failure.dart';
import 'package:hi_net/presentation/common/utils/state_render.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

mixin PaginationMixin<E, S> on Bloc<E, S> {
  /// Map to store pages for different list types
  final Map<String, int> _pages = {};

  /// Get current page for a specific key
  int getPage(String key) {
    return _pages[key] ?? 1;
  }

  /// Set page for a specific key
  void setPage(String key, int page) {
    _pages[key] = page;
  }

  /// Increment page for a specific key
  void incrementPage(String key) {
    _pages[key] = getPage(key) + 1;
  }

  /// Reset page to 1
  void resetPage(String key) {
    _pages[key] = 1;
  }

  /// Handle pagination logic
  Future<void> handlePagination<T>({
    required String key,
    required RefreshController controller,
    required bool isRefresh,
    required Emitter<S> emit,
    required S Function() loadingState,
    required S Function(String errorMessage, ReqState reqState, Failure? failure) errorState,
    required S Function(List<T> items, bool isRefresh) successState,
    required Future<Either<Failure, PaginatedResponse<T>>> Function(int page)
    fetchData,
    required List<T> currentItems,

    /// Current items in state
  }) async {
    int currentPage = getPage(key);

    /// Handle refresh
    if (isRefresh) {
      resetPage(key);
      currentPage = 1;
      emit(loadingState());
      controller.refreshCompleted(resetFooterState: true);
    }

    /// Fetch data
    Either<Failure, PaginatedResponse<T>> response = await fetchData(
      currentPage,
    );

    response.fold(
      (failure) {
        if (!isRefresh) {
          controller.loadFailed();
        } else {
          emit(errorState(failure.userMessage, ReqState.error, failure));
        }
      },
      (data) {
        /// Check if empty on refresh
        if (isRefresh && data.items.isEmpty) {
          emit(errorState(Translation.no_result_available.tr, ReqState.empty, null));

          /// Use your translation
          return;
        }

        if (!isRefresh && data.items.isEmpty) {
          controller.loadNoData();
          return;
        }

        /// Check if last page
        if (data.meta.lastPage == data.meta.currentPage) {
          controller.loadNoData();
        } else if (!isRefresh) {
          controller.loadComplete();
        }

        /// Increment page for next load
        incrementPage(key);

        /// Emit success state with items
        emit(
          successState(
            isRefresh ? data.items : [...currentItems, ...data.items],
            isRefresh,
          ),
        );
      },
    );
  }

  /// Clean up pages map (controllers are managed by you)
  void disposePaginationMixin() {
    _pages.clear();
  }
}

/// Generic paginated response interface
class PaginatedResponse<T> {
  final List<T> items;
  final PaginationMeta meta;

  PaginatedResponse({required this.items, required this.meta});
}

class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int total;

  PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}
