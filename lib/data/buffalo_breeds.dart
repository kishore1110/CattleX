class BuffaloBreeds {
  static String getDetailedDescription(String breedName) {
    switch (breedName) {
      case 'Murrah Buffalo':
        return '''Colour: Jet black with white markings on face, tail, and legs. Skin is black with sparse hair.

Horn Shape & Size: Tightly curled, forming complete rings. Strong and well-developed horns.

Characteristics: World's best dairy buffalo breed. Excellent milk production with high fat content.

Origin: Haryana, India. Considered the best buffalo breed for milk production globally.

Physical Features: Bulls weigh 550-650 kg, females weigh 450-550 kg. Well-developed udder with prominent milk veins.

Special Qualities: Highest milk yield among buffalo breeds, excellent feed conversion, good fertility and longevity.''';

      case 'Nili-Ravi Buffalo':
        return '''Colour: Black with white markings on face, legs, and tail tip. Distinctive white collar around neck.

Horn Shape & Size: Tightly curled, similar to Murrah but slightly larger.

Characteristics: High milk producing breed with excellent quality. Good heat tolerance and disease resistance.

Origin: Punjab region of India and Pakistan. Developed along Ravi river belt.

Physical Features: Larger than Murrah. Bulls weigh 600-700 kg, females weigh 500-600 kg.

Special Qualities: High milk yield with good fat percentage, excellent mothering ability, and good longevity.''';

      case 'Surti Buffalo':
        return '''Colour: Black to dark brown. Some animals may have grey or silver markings.

Horn Shape & Size: Sickle-shaped, curved backward and upward. Medium sized horns.

Characteristics: Compact breed with rich milk quality. High fat content in milk makes it ideal for dairy products.

Origin: Kaira and Baroda districts of Gujarat. Well adapted to coastal regions.

Physical Features: Smaller than Murrah. Bulls weigh 400-500 kg, females weigh 350-450 kg.

Special Qualities: Rich milk with high fat content (7-8%), excellent for ghee and butter production.''';

      case 'Jaffarabadi Buffalo':
        return '''Colour: Black with white markings on face and legs. Large and massive build.

Horn Shape & Size: Large, thick, and curved. Well-developed horn structure.

Characteristics: Largest buffalo breed in India. Excellent draught capacity and good milk production.

Origin: Jaffarabad district of Gujarat. Primarily used for draught purposes.

Physical Features: Very large size. Bulls weigh 700-800 kg, females weigh 600-700 kg.

Special Qualities: Excellent draught power, good milk production, hardy and disease resistant.''';

      default:
        return 'Detailed information about this buffalo breed will be available soon. Please visit the official Pashupedia website for more comprehensive breed information.';
    }
  }

  static List<Map<String, String>> getBuffaloBreeds() {
    return [
      {
        'title': 'Murrah Buffalo',
        'description': 'Famous buffalo breed with excellent milk production and fat content.',
        'image': 'assets/images/murrah_buffalo.jpg',
        'yield': '18-25L/day',
      },
      {
        'title': 'Nili-Ravi Buffalo',
        'description': 'High-yielding buffalo breed from Punjab with superior milk quality.',
        'image': 'assets/images/murrah_buffalo.jpg',
        'yield': '20-28L/day',
      },
      {
        'title': 'Surti Buffalo',
        'description': 'Compact buffalo breed from Gujarat known for rich milk with high fat content.',
        'image': 'assets/images/murrah_buffalo.jpg',
        'yield': '8-12L/day',
      },
      {
        'title': 'Jaffarabadi Buffalo',
        'description': 'Large buffalo breed from Gujarat with excellent draught capacity.',
        'image': 'assets/images/murrah_buffalo.jpg',
        'yield': '12-18L/day',
      },
    ];
  }
}
