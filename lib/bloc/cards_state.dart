part of 'cards_bloc.dart';

enum CardsStatus { initial, success, failure }

final class CardsState extends Equatable {
  const CardsState({
    this.status = CardsStatus.initial,
    this.cards = const <CharacterModel>[],
    this.hasReachedMax = false,
  });

  final CardsStatus status;
  final List<CharacterModel> cards;
  final bool hasReachedMax;

  CardsState copyWith({
    CardsStatus? status,
    List<CharacterModel>? cards,
    bool? hasReachedMax,
  }) {
    return CardsState(
        status: status ?? this.status,
        cards: cards ?? this.cards,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override  
  String toString() {
    return '''CardState {status: $status, hasReachedMax: $hasReachedMax, cards: ${cards.length}''';
  }

  @override
  List<Object> get props => [status, cards, hasReachedMax];
}
