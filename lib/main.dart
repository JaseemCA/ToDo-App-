import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Bloc/bloc.dart';
import 'package:todo/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TO DO',
          theme: ThemeData.dark(),
          home: const Homepage()),
    );
  }
}
