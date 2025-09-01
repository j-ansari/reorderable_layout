part of 'layout_cubit.dart';

class LayoutState extends Equatable {
  final List<LayoutItem> items;
  final int version;

  const LayoutState({this.items = const [], this.version = 0});

  LayoutState copyWith({List<LayoutItem>? items, int? version}) {
    return LayoutState(
      items: items ?? this.items,
      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [items, version];
}
