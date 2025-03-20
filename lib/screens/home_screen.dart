import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:ram_cards/bloc/cards_bloc.dart';
import 'package:ram_cards/cubit/theme_cubit.dart';
import 'package:ram_cards/widgets/character_list_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeCubit>().state;
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: BlocProvider(
        create: (context) =>
            CardsBloc(httpClient: http.Client())..add(CardsFetched()),
        child: const CharacterListView(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_border), label: 'Favorites'),
        ],
        currentIndex:
            GoRouterState.of(context).uri.toString() == '/favorites' ? 1 : 0,
        onTap: (index) {
          if (index == 0) {
            context.go('/');
          } else {
            context.go('/favorites');
          }
        },
      ),
      floatingActionButton: theme is LightTheme
          ? FloatingActionButton(
              onPressed: () {
                context.read<ThemeCubit>().changeToLightMode();
              },
              child: Icon(Icons.light_mode),
            )
          : FloatingActionButton(
              onPressed: () {
                context.read<ThemeCubit>().changeToDarkMode();
              },
              child: Icon(Icons.dark_mode),
            ),
    );
  }
}
