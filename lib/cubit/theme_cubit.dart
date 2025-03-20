import 'package:bloc/bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(LightTheme());

  void changeToDarkMode() {
    return emit(LightTheme());
  }

  void changeToLightMode() {
    return emit(DarkTheme());
  }
}
