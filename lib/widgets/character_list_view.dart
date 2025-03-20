import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ram_cards/bloc/cards_bloc.dart';
import 'package:ram_cards/widgets/character_card.dart';


class CharacterListView extends StatefulWidget {
  const CharacterListView({super.key});

  @override
  State<CharacterListView> createState() => _CharacterListViewState();
}

class _CharacterListViewState extends State<CharacterListView> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardsBloc, CardsState>(
      builder: (context, state) {
        switch (state.status) {
          case CardsStatus.failure:
            return const Center(
              child: Text("Failed to fetch posts"),
            );
          case CardsStatus.success:
            if (state.cards.isEmpty) {
              return const Center(
                child: Text("No cards"),
              );
            }
            return ScrollConfiguration(
                behavior: MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse
                  },
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
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.cards.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return CardOfCharacter(
                        card: state.cards[index],
                      );
                    },
                  ),
                ),
              );
          case CardsStatus.initial:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<CardsBloc>().add(CardsFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}