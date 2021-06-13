import 'package:clean_architecture_tdd/features/number_trivia/presentation/screens/number_trivia_screen.dart';
import 'package:clean_architecture_tdd/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); //! Dependency Injection For all the various features in a single call
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NumberTriviaBloc>(),
      child: MaterialApp(
        title: 'Number Trivia App',
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: Colors.green[800],
        ),
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.green[800],
        ),
        home: NumberTriviaScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
