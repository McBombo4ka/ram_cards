class CharacterModel {
  CharacterModel(
      {required this.id,
      required this.name,
      required this.locationName,
      required this.status,
      required this.image});

  final int id;
  final String name;
  final String locationName;
  final String status;
  final String image;

  factory CharacterModel.fromJson(Map<String, dynamic> data) {
    try {
      return CharacterModel(
        id: data["id"] as int,
        name: data["name"] as String,
        locationName: data["location"]["name"] as String,
        status: data['status'] as String,
        image: data["image"] as String,
      );
    } catch (e) {
      throw FormatException('Invalid JSON structure: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "location": {
        "name": locationName,
      },
      "status": status,
      "image": image,
    };
  }
}

class LocationInformation {
  LocationInformation({required this.name});

  final String name;
}
