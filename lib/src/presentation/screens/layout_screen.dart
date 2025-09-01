import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout_cubit/layout_cubit.dart';
import '../widgets/app_button.dart';
import '../widgets/grid_layout.dart';

class ReorderableLayoutScreen extends StatelessWidget {
  const ReorderableLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (state.items.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return ResponsiveGridLayout(
                          key: ValueKey(state.version),
                          items: state.items,
                          constraints: constraints,
                          onResize:
                              (index) =>
                                  context.read<LayoutCubit>().resizeItem(index),
                          onReorder:
                              (oldIndex, newIndex) => context
                                  .read<LayoutCubit>()
                                  .reorder(oldIndex, newIndex),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      AppButton(
                        icon: Icons.add_circle_outline,
                        label: 'Add',
                        color: Colors.blueAccent,
                        onPressed: () => context.read<LayoutCubit>().addItem(),
                      ),
                      AppButton(
                        icon: Icons.delete_outline,
                        label: 'Clear All',
                        color: Colors.grey,
                        onPressed: () => context.read<LayoutCubit>().clearAll(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
