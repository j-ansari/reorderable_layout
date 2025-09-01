import 'dart:math';
import 'dart:ui';
import '../model/layout_model.dart';

class LayoutUtils {
  static const double aspectRatio = 16 / 9;
  static const double spacing = 8;
  static List<Rect> calculateLayout(
    List<LayoutItem> items,
    double maxWidth,
    double maxHeight,
  ) {
    if (items.isEmpty) return [];

    List<Rect> bestConceptualLayout = [];
    double bestScore = double.negativeInfinity;
    final containerAspectRatio = maxWidth / maxHeight;

    for (int cols = 1; cols <= items.length * 2; cols++) {
      if (cols == 0) continue;
      final conceptualRects = <Rect>[];
      final colHeights = List<int>.filled(cols, 0);
      bool possible = true;

      for (final item in items) {
        if (item.widthFlex > cols) {
          possible = false;
          break;
        }
        int bestY = 1 << 30;
        int bestX = -1;
        for (int x = 0; x <= cols - item.widthFlex; x++) {
          int currentMaxY = 0;
          for (int i = 0; i < item.widthFlex; i++) {
            currentMaxY = max(currentMaxY, colHeights[x + i]);
          }
          if (currentMaxY < bestY) {
            bestY = currentMaxY;
            bestX = x;
          }
        }
        if (bestX != -1) {
          final rect = Rect.fromLTWH(
            bestX.toDouble(),
            bestY.toDouble(),
            item.widthFlex.toDouble(),
            item.heightFlex.toDouble(),
          );
          conceptualRects.add(rect);
          for (int i = 0; i < item.widthFlex; i++) {
            colHeights[bestX + i] = bestY + item.heightFlex;
          }
        } else {
          possible = false;
          break;
        }
      }

      if (!possible) continue;
      final conceptualWidth = cols;
      final conceptualHeight =
          colHeights.isNotEmpty ? colHeights.reduce(max) : 0;
      if (conceptualHeight == 0) continue;
      final layoutAspectRatio =
          (conceptualWidth * aspectRatio) / conceptualHeight;
      final score = -((layoutAspectRatio - containerAspectRatio).abs());
      if (score > bestScore) {
        bestScore = score;
        bestConceptualLayout = conceptualRects;
      }
    }

    if (bestConceptualLayout.isEmpty) return [];
    double finalConceptualWidth = 0;
    double finalConceptualHeight = 0;
    for (final rect in bestConceptualLayout) {
      finalConceptualWidth = max(finalConceptualWidth, rect.right);
      finalConceptualHeight = max(finalConceptualHeight, rect.bottom);
    }

    if (finalConceptualWidth == 0 || finalConceptualHeight == 0) return [];

    final uWidthByWidth =
        (maxWidth - (finalConceptualWidth - 1) * spacing) /
        finalConceptualWidth;
    final uHeightByWidth = uWidthByWidth / aspectRatio;
    final totalHeight =
        finalConceptualHeight * uHeightByWidth +
        (finalConceptualHeight - 1) * spacing;
    final uHeightByHeight =
        (maxHeight - (finalConceptualHeight - 1) * spacing) /
        finalConceptualHeight;
    final uWidthByHeight = uHeightByHeight * aspectRatio;
    double unitWidth;
    double unitHeight;

    if (totalHeight <= maxHeight) {
      unitWidth = uWidthByWidth;
      unitHeight = uHeightByWidth;
    } else {
      unitWidth = uWidthByHeight;
      unitHeight = uHeightByHeight;
    }

    final finalPixelLayout = <Rect>[];
    final totalLayoutWidth =
        finalConceptualWidth * unitWidth + (finalConceptualWidth - 1) * spacing;
    final totalLayoutHeight =
        finalConceptualHeight * unitHeight +
        (finalConceptualHeight - 1) * spacing;
    final offsetX = max(0, (maxWidth - totalLayoutWidth) / 2.0);
    final offsetY = max(0, (maxHeight - totalLayoutHeight) / 2.0);

    for (int i = 0; i < items.length; i++) {
      final conceptualRect = bestConceptualLayout[i];
      final item = items[i];
      final left = conceptualRect.left * (unitWidth + spacing) + offsetX;
      final top = conceptualRect.top * (unitHeight + spacing) + offsetY;
      final width = item.widthFlex * unitWidth + (item.widthFlex - 1) * spacing;
      final height =
          item.heightFlex * unitHeight + (item.heightFlex - 1) * spacing;
      finalPixelLayout.add(Rect.fromLTWH(left, top, width, height));
    }
    return finalPixelLayout;
  }
}
