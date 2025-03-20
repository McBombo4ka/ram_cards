import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:ram_cards/api_model/character_model.dart';

part 'cards_event.dart';
part 'cards_state.dart';

const throttleDuration = Duration(milliseconds: 1000);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class CardsBloc extends Bloc<CardsEvent, CardsState> {
  CardsBloc({required this.httpClient}) : super(const CardsState()) {
    on<CardsFetched>(_onFetched,
        transformer: throttleDroppable(throttleDuration));
  }

  final http.Client httpClient;

  Future<void> _onFetched(CardsFetched event, Emitter<CardsState> emit) async {
    if (state.hasReachedMax) return;

    try {
      final cards = await _fetchCards(startIndex: state.cards.length + 1);
      if (cards.isEmpty) {
        return emit(state.copyWith(hasReachedMax: true));
      }

      emit(state.copyWith(
        status: CardsStatus.success,
        cards: [...state.cards, ...cards],
      ));
    } catch (e) {
      emit(state.copyWith(status: CardsStatus.failure));
    }
  }

  Future<List<CharacterModel>> _fetchCards({required int startIndex}) async {
    StringBuffer arr = StringBuffer();
    for (int i = startIndex; i <= startIndex + 10; i++) {
      arr.write("$i,");
    }
    // WARNING
    // BAD CODING
    final response = await httpClient.get(
      Uri.https('rickandmortyapi.com', '/api/character/$arr'),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return CharacterModel(
            id: map['id'] as int,
            name: map['name'] as String,
            locationName: map['location']['name'] as String,
            status: map['status'] as String,
            image: map['image']);
      }).toList();
    }
    throw Exception('error fetching posts');
  }
}
