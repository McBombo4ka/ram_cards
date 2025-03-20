part of 'cards_bloc.dart';


@immutable
sealed class CardsEvent extends Equatable {
  @override  
  List<Object> get props => [];
}

final class CardsFetched extends CardsEvent{}