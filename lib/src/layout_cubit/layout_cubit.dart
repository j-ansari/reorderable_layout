import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/layout_model.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(const LayoutState());

  final _resizePresets = <Map<String, int>>[
    {'w': 1, 'h': 1},
    {'w': 2, 'h': 1},
    {'w': 2, 'h': 2},
    {'w': 1, 'h': 2},
  ];

  void addItem() {
    final newItem = LayoutItem(id: state.items.length);
    emit(
      state.copyWith(
        items: [...state.items, newItem],
        version: state.version + 1,
      ),
    );
  }

  void clearAll() {
    emit(state.copyWith(items: [], version: state.version + 1));
  }

  void resizeItem(int index) {
    final items = [...state.items];
    final item = items[index];
    final newPresetIndex = (item.presetIndex + 1) % _resizePresets.length;
    final newPreset = _resizePresets[newPresetIndex];

    items[index] = item.copyWith(
      presetIndex: newPresetIndex,
      widthFlex: newPreset['w']!,
      heightFlex: newPreset['h']!,
    );

    emit(state.copyWith(items: items, version: state.version + 1));
  }

  void reorder(int oldIndex, int newIndex) {
    final items = [...state.items];
    if (newIndex > oldIndex) newIndex -= 1;
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    emit(state.copyWith(items: items, version: state.version + 1));
  }
}
