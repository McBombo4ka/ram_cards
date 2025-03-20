import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ram_cards/screens/favorites_screen.dart';
import 'package:ram_cards/screens/home_screen.dart';
import 'package:ram_cards/cubit/theme_cubit.dart';
import 'package:ram_cards/simple_bloc_observer.dart';
import 'package:go_router/go_router.dart';

// Я не успел доделать. Был слишком самоуверенным и сделал только половину так, как хотел.
// Когда я понял, что мне не хватает времени, то начал чудить непонятно что и выглядит, честно говоря, это ужасно.
// Тогда почему я это отправил? А мало ли получится.
// Мало ли получится..

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('favorites');
  await Hive.openBox('cache');
  Bloc.observer = const SimpleBlocObserver();
  runApp(const MainApp());
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => FavoritesScreen(),
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            theme: state is DarkTheme ? ThemeData.light() : ThemeData.dark(),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
