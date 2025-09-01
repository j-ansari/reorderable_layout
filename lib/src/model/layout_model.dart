class LayoutItem {
  final int id;
  int widthFlex;
  int heightFlex;
  int presetIndex;

  LayoutItem({
    required this.id,
    this.widthFlex = 1,
    this.heightFlex = 1,
    this.presetIndex = 0,
  });

  LayoutItem copyWith({int? widthFlex, int? heightFlex, int? presetIndex}) {
    return LayoutItem(
      id: id,
      widthFlex: widthFlex ?? this.widthFlex,
      heightFlex: heightFlex ?? this.heightFlex,
      presetIndex: presetIndex ?? this.presetIndex,
    );
  }
}
