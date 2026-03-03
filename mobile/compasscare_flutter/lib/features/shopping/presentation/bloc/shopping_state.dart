part of 'shopping_bloc.dart';

enum ShoppingStatus { initial, loading, success, failure }

enum ShoppingNoticeType { success, error }

class ShoppingNotice extends Equatable {
  const ShoppingNotice({
    required this.id,
    required this.message,
    required this.type,
  });

  final int id;
  final String message;
  final ShoppingNoticeType type;

  @override
  List<Object?> get props => [id, message, type];
}

class ShoppingState extends Equatable {
  const ShoppingState({
    this.status = ShoppingStatus.initial,
    this.data,
    this.isRefreshing = false,
    this.isFromCache = false,
    this.isStaticOnly = false,
    this.notice,
  });

  final ShoppingStatus status;
  final ShoppingData? data;
  final bool isRefreshing;
  final bool isFromCache;
  final bool isStaticOnly;
  final ShoppingNotice? notice;

  bool get isInitialLoading => status == ShoppingStatus.loading && data == null;

  ShoppingState copyWith({
    ShoppingStatus? status,
    ShoppingData? data,
    bool setNullData = false,
    bool? isRefreshing,
    bool? isFromCache,
    bool? isStaticOnly,
    ShoppingNotice? notice,
    bool clearNotice = false,
  }) {
    return ShoppingState(
      status: status ?? this.status,
      data: setNullData ? null : (data ?? this.data),
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isFromCache: isFromCache ?? this.isFromCache,
      isStaticOnly: isStaticOnly ?? this.isStaticOnly,
      notice: clearNotice ? null : (notice ?? this.notice),
    );
  }

  @override
  List<Object?> get props => [
    status,
    data,
    isRefreshing,
    isFromCache,
    isStaticOnly,
    notice,
  ];
}
