import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_notes/config/themes.dart';

import 'blocs/blocs.dart';
import 'repositories/repositories.dart';
import 'screens/screens.dart';
import 'package:video_player/video_player.dart';
void main() {
 // VideoPlayerController _vcontroller;
  Bloc.observer = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(ThemeState(themeData: Themes.themeData[AppTheme.LightTheme]))..add(LoadTheme()),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            authRepository: AuthRepository(),
          )..add(AppStarted()),
        ),
        BlocProvider<NotesBloc>(
          create: (_) => NotesBloc(
            authRepository: AuthRepository(),
            notesRepository: NotesRepository(),
          ),
        )

      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Firebase Bloc Notes',
            debugShowCheckedModeBanner: false,
            theme: state.themeData,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
