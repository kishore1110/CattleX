class BuffaloBreeds {
  static String getDetailedDescription(String breedName) {
    switch (breedName) {
      case 'Banni':
        return '''	
Colour: Mainly Black, some times Copper colour.

Horn Shape & Size : Curved. Medium to large, heavy with 24 to 30cm diameter in adult animals.

Visible Characteristic :Horns are vertical and upward in direction with inverted double/single coiling.''';

      case 'Bargur':
        return '''	
Coat colors vary from black to light brown or brownish black. Greyish white stockings from carpal/tarsal joint to fetlock are present predominantly in females. These buffaloes are maintained under extensive system and are reared for manure, milk and meat (male calves are sold for cara-beef). The animals are adapted to graze in the hilly terrain due its small size (about 102cm in height). The milk yield of the animals ranges from 1.5 to 2.0 liters per day and mainly used for house hold consumption.''';


      case 'Bhadawari':
        return '''They are blackish copper to light copper coloured with wheat straw-like colour over the legs.Two white lines, “Chevron”, called as “Kanthy” in local language, are present on lower side of the neck.Horns are black curling slightly outward and downward before running parallel backward near neck and finally turning upward.''';

      case 'Chhattisgarhi':
        return '''	
Coat colour is black. Animals are medium built with proportionate body. Horns are medium to large in size and directed laterally backwards and then upwards with pointing tips. These buffaloes are reared under extensive system for providing draught power, milk and meat. Males have excellent ploughing ability, and preferred over cow bullocksspecifically in rice fields. Milk yield ranges from 3 to 6 kg/day.''';

      case 'Chilika':
        return '''	
Colour : Brown is hblack or Black Horn.

Shape & Size :Curved Upward, inward. 

Visible Characteristic: Medium sized with compact body, strong legs and small udder. Habitatis chilka lake.''';

      default:
        return 'Detailed information about this buffalo breed will be available soon. Please visit the official Pashupedia website for more comprehensive breed information.';
    }
  }

  static List<Map<String, String>> getBuffaloBreeds() {
    return [
      {
        'title': 'Banni',
        'description': 'Resilient breed from Kutch, Gujarat; night grazer, disease-resistant, high milk.',
        'image': 'assets/images/Banni.jpg',
        'yield': '12-18L/day',
      },
      {
        'title': 'Bargur',
        'description': 'Indigenous breed from Tamil Nadu, sturdy, adapted to hilly terrain.',
        'image': 'assets/images/Bargur_buffalo.jpg',
        'yield': '3-5L/day',
      },
      {
        'title': 'Bhadawari',
        'description': 'Breed from Uttar Pradesh–Madhya Pradesh border, copper-colored, high-fat milk.',
        'image': 'assets/images/Bhadawari.jpg',
        'yield': '4-7L/day',
      },
      {
        'title': 'Chhattisgarhi',
        'description': 'Indigenous buffalo breed from Chhattisgarh, hardy, well-suited for local farming.',
        'image': 'assets/images/Chhattisgarhi.jpg',
        'yield': '4-6L/day',
      },
      {
        'title': 'Chilika',
        'description': 'Indigenous buffalo breed from Odisha, thrives in marshy wetland areas.',
        'image': 'assets/images/Chilika.jpg',
        'yield': '2-4L/day',
      },
    ];
  }
}
