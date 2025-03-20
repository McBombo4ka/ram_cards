import 'package:flutter/material.dart';
import 'package:ram_cards/api_model/character_model.dart';
import 'package:ram_cards/services/local_storage.dart';

class CardOfCharacter extends StatelessWidget {
  const CardOfCharacter({required this.card, super.key});

  final CharacterModel card;

  @override
  Widget build(BuildContext context) {
    final storageApi = LocalStorageService();
    return SizedBox(
      width: 400,
      height: double.infinity,
      child: Card.outlined(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                  width: 300, height: 300, child: Image.network(card.image)),
              Text(""),
              Text(
                card.name,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              Text(
                card.locationName,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle,
                      size: 16,
                      color: card.status == "Alive"
                          ? Colors.green
                          : card.status == "Dead"
                              ? Colors.red
                              : Colors.blueGrey),
                  Text(
                    " ${card.status.toLowerCase()}",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.star_border_outlined),
                    onPressed: () {
                      storageApi.addFavorite(card);
                    },
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.delete_outline),
                    onPressed: () {
                      storageApi.removeFavorite(card.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}