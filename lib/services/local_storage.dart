import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:ram_cards/api_model/character_model.dart';

class LocalStorageService {
  static const String favoritesBox = 'favorites';
  static const String cacheBox = 'cache';

  // Методы для работы с избранным
  Future<void> addFavorite(CharacterModel character) async {
    final box = Hive.box(favoritesBox);
    await box.put(character.id, json.encode(character.toJson()));
    print("added $box");
  }

  Future<void> removeFavorite(int id) async {
    final box = Hive.box(favoritesBox);
    await box.delete(id);
  }

  Future<List<CharacterModel>> getFavorites() async {
    final box = await Hive.openBox(favoritesBox); // Открытие коробки данных
    return box.values.map((data) {
      final jsonData = json.decode(data);
      return CharacterModel.fromJson(jsonData);
    }).toList();
  }

  bool isFavorite(int id) {
    final box = Hive.box(favoritesBox);
    return box.containsKey(id);
  }

  // Методы для кэширования данных
  Future<void> cacheCharacters(
      int page, List<CharacterModel> characters) async {
    final box = Hive.box(cacheBox);
    List<Map<String, dynamic>> jsonList =
        characters.map((c) => c.toJson()).toList();
    await box.put('page_$page', json.encode(jsonList));
  }

  List<CharacterModel>? getCachedCharacters(int page) {
    final box = Hive.box(cacheBox);
    if (box.containsKey('page_$page')) {
      final data = box.get('page_$page');
      List<dynamic> jsonList = json.decode(data);
      return jsonList.map((json) => CharacterModel.fromJson(json)).toList();
    }
    return null;
  }
}
