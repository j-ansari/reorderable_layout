import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/layout_cubit/layout_cubit.dart';
import 'src/presentation/screens/layout_screen.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => LayoutCubit(),
      child: const ReorderableLayoutApp(),
    ),
  );
}

class ReorderableLayoutApp extends StatelessWidget {
  const ReorderableLayoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ReorderableLayoutScreen(),
    );
  }
}
