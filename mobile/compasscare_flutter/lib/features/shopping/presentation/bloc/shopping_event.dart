part of 'shopping_bloc.dart';

sealed class ShoppingEvent extends Equatable {
  const ShoppingEvent();

  @override
  List<Object?> get props => [];
}

class ShoppingRequested extends ShoppingEvent {
  const ShoppingRequested();
}

class ShoppingRefreshed extends ShoppingEvent {
  const ShoppingRefreshed();
}

class ShoppingNoticeCleared extends ShoppingEvent {
  const ShoppingNoticeCleared();
}
