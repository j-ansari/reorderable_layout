import 'package:flutter/material.dart';
import '../../model/layout_model.dart';
import '../../utils/layout_utils.dart';

class ResponsiveGridLayout extends StatelessWidget {
  final List<LayoutItem> items;
  final BoxConstraints constraints;
  final Function(int) onResize;
  final Function(int, int) onReorder;

  const ResponsiveGridLayout({
    super.key,
    required this.items,
    required this.constraints,
    required this.onResize,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final itemsLayout = LayoutUtils.calculateLayout(
      items,
      constraints.maxWidth,
      constraints.maxHeight,
    );

    if (itemsLayout.isEmpty) return const SizedBox.shrink();
    return Stack(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final rect = itemsLayout[index];
        return Positioned(
          left: rect.left,
          top: rect.top,
          width: rect.width,
          height: rect.height,
          child: LongPressDraggable<int>(
            data: index,
            feedback: Transform.scale(
              scale: 1.05,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(8),
                child: boxItem(context, item, index),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.4,
              child: boxItem(context, item, index),
            ),
            child: DragTarget<int>(
              onWillAcceptWithDetails: (details) => details.data != index,
              onAcceptWithDetails: (details) => onReorder(details.data, index),
              builder: (context, _, __) => boxItem(context, item, index),
            ),
          ),
        );
      }),
    );
  }

  Widget boxItem(BuildContext context, LayoutItem item, int index) {
    return GestureDetector(
      onTap: () => onResize(index),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.primaries[item.id % Colors.primaries.length].shade300,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12, width: 1),
        ),
        child: Text(
          'Item ${item.id + 1}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
