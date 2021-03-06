import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_notes/blocs/blocs.dart';
import 'package:flutter_bloc_notes/config/themes.dart';
import 'package:flutter_bloc_notes/repositories/repositories.dart';
import 'package:flutter_bloc_notes/screens/home.dart';
import 'package:flutter_bloc_notes/widgets/widgets.dart';

import 'screens.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        //fetch notes
        BlocProvider.of<NotesBloc>(context).add(FetchNotes());
      },
      builder: (context, authState) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider<NoteDetailBloc>(
                  create: (_) => NoteDetailBloc(
                    authBloc: BlocProvider.of<AuthBloc>(context),
                    notesRepository: NotesRepository(),
                  ),
                  child: NoteDetailScreen(),
                ),
              ),
            ),
          ),
          body: BlocBuilder<NotesBloc, NotesState>(
            builder: (context, notesState) {
              return _buildBody(context, authState, notesState);
            },
          ),
        );
      },
    );
  }

  Stack _buildBody(
      BuildContext context, AuthState authState, NotesState notesState) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Your Notes'),
              ),
              leading: IconButton(
                icon: authState is Authenticated
                    ? Icon(Icons.exit_to_app)
                    : Icon(Icons.account_circle),
                iconSize: 28.0,
                onPressed: () => authState is Authenticated
                    ? BlocProvider.of<AuthBloc>(context).add(Logout())
                    : Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider<LoginBloc>(
                            create: (_) => LoginBloc(
                              authBloc: BlocProvider.of<AuthBloc>(context),
                              authRepository: AuthRepository(),
                            ),
                            child: LoginScreen(),
                          ),
                        ),
                      ),
              ),
              actions: <Widget>[_buildThemeIconButton(context)],
            ),
            notesState is NotesLoaded
                ? NotesGrid(
                    notes: notesState.notes,
                    onTap: (note) => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider<NoteDetailBloc>(
                          create: (_) => NoteDetailBloc(
                            authBloc: BlocProvider.of<AuthBloc>(context),
                            notesRepository: NotesRepository(),
                          )..add(NoteLoaded(note: note)),
                          child: NoteDetailScreen(note: note),
                        ),
                      ),
                    ),
                  )
                : const SliverPadding(padding: EdgeInsets.zero),
          ],
        ),
        notesState is NotesLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox.shrink(),
        notesState is NotesError
            ?MaterialApp(home: Home())/*Center(
                child: Text(
                  'Something went wrong!\nPlease check your connection.',

                  textAlign: TextAlign.center,
                ),
              )*/
            : const SizedBox.shrink(),
      ],
    );
  }

  IconButton _buildThemeIconButton(BuildContext context) {
    final bool isLightTheme = BlocProvider.of<ThemeBloc>(context).state.themeData ==
        Themes.themeData[AppTheme.LightTheme];

    return IconButton(
      icon: isLightTheme ? Icon(Icons.brightness_4) : Icon(Icons.brightness_5),
      iconSize: 28.0,
      onPressed: () => BlocProvider.of<ThemeBloc>(context).add(UpdateTheme()),
    );
  }
}
