import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ram_cards/api_model/character_model.dart';
import 'package:ram_cards/cubit/theme_cubit.dart';
import 'package:ram_cards/services/local_storage.dart';
import 'package:ram_cards/widgets/character_card.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeCubit>().state;
    final storage = LocalStorageService();
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: FutureBuilder<List<CharacterModel>>(
        future: storage
            .getFavorites(), // Используем метод getFavorites() для получения данных
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Показываем индикатор загрузки
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorites yet!'));
          } else {
            final favorites = snapshot.data!; // Получаем список персонажей

            return ScrollConfiguration(
              behavior: MaterialScrollBehavior().copyWith(
                dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
              ),
              child: Listener(
                onPointerSignal: (event) {
                  if (event is PointerScrollEvent) {
                    _scrollController.jumpTo(
                      _scrollController.offset + event.scrollDelta.dy * 0.6,
                    );
                  }
                },
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final character = favorites[index];
                    return CardOfCharacter(
                      card: character,
                    );
                  },
                ),
              ),
            );
          }
        },
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
