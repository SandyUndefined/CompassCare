import 'package:compasscare_flutter/features/shopping/domain/models/shopping_models.dart';
import 'package:compasscare_flutter/features/shopping/domain/repositories/shopping_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'shopping_event.dart';
part 'shopping_state.dart';

class ShoppingBloc extends Bloc<ShoppingEvent, ShoppingState> {
  ShoppingBloc({required ShoppingRepository repository})
    : _repository = repository,
      super(const ShoppingState()) {
    on<ShoppingRequested>(_onShoppingRequested);
    on<ShoppingRefreshed>(_onShoppingRefreshed);
    on<ShoppingNoticeCleared>(_onShoppingNoticeCleared);
  }

  final ShoppingRepository _repository;
  int _noticeCounter = 0;

  Future<void> _onShoppingRequested(
    ShoppingRequested event,
    Emitter<ShoppingState> emit,
  ) async {
    await _loadData(emit, isRefresh: false);
  }

  Future<void> _onShoppingRefreshed(
    ShoppingRefreshed event,
    Emitter<ShoppingState> emit,
  ) async {
    await _loadData(emit, isRefresh: true);
  }

  Future<void> _loadData(
    Emitter<ShoppingState> emit, {
    required bool isRefresh,
  }) async {
    if (isRefresh) {
      emit(state.copyWith(isRefreshing: true, clearNotice: true));
    } else {
      emit(state.copyWith(status: ShoppingStatus.loading, clearNotice: true));
    }

    try {
      final result = await _repository.loadShoppingData();
      emit(
        state.copyWith(
          status: ShoppingStatus.success,
          data: result.data,
          isFromCache: result.origin == ShoppingDataOrigin.cache,
          isStaticOnly: result.origin == ShoppingDataOrigin.staticOnly,
          isRefreshing: false,
          clearNotice: true,
        ),
      );
    } catch (_) {
      if (state.data != null) {
        emit(
          state.copyWith(
            isRefreshing: false,
            notice: _createNotice(
              type: ShoppingNoticeType.error,
              message: 'Unable to refresh shopping data right now.',
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ShoppingStatus.failure,
            isRefreshing: false,
            notice: _createNotice(
              type: ShoppingNoticeType.error,
              message: 'Unable to load shopping data. Please try again.',
            ),
          ),
        );
      }
    }
  }

  void _onShoppingNoticeCleared(
    ShoppingNoticeCleared event,
    Emitter<ShoppingState> emit,
  ) {
    emit(state.copyWith(clearNotice: true));
  }

  ShoppingNotice _createNotice({
    required ShoppingNoticeType type,
    required String message,
  }) {
    _noticeCounter += 1;
    return ShoppingNotice(id: _noticeCounter, message: message, type: type);
  }
}
