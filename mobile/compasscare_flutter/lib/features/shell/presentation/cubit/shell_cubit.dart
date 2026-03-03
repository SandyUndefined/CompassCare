import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShellState extends Equatable {
  const ShellState({required this.tabIndex, this.loadedTabIndices = const [0]});

  final int tabIndex;
  final List<int> loadedTabIndices;

  @override
  List<Object?> get props => [tabIndex, loadedTabIndices];
}

class ShellCubit extends Cubit<ShellState> {
  ShellCubit() : super(const ShellState(tabIndex: 0));

  void selectTab(int index) {
    if (index == state.tabIndex) {
      return;
    }

    final loaded = state.loadedTabIndices.contains(index)
        ? state.loadedTabIndices
        : [...state.loadedTabIndices, index];

    emit(ShellState(tabIndex: index, loadedTabIndices: loaded));
  }
}
