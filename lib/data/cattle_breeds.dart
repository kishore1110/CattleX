class CattleBreeds {
  static String getDetailedDescription(String breedName) {
    switch (breedName) {
      case 'Gir':
        return '''
Colour: Red with white patches. The face and lower abdomen are white in colour with black muzzle.

Horn Shape & Size: Curved upward and inward, sickle shaped.

Characteristics: Medium sized strong dual type, and migratory animal of lower Himalayas. White face along with some regions of Hump, neck, and dewlap are white. In males, Hump and neck region are dark in colour irrespective of coat colour.

Origin: Gujarat, India. The Gir breed is one of the most important zebu breeds of India.

Physical Features: The average body weight of adult bulls is 545 kg and adult cows is 385 kg. The average milk yield is 1590 kg per lactation.

Special Qualities: Known for heat tolerance, disease resistance, and good mothering ability. Excellent for crossbreeding programs.''';

      case 'Sahiwal':
        return '''
Colour: Brownish red; shades may vary from mahogany red-brown to more greyish red. Extremities in bulls are darker. Occasionally there are white patches.

Horn Shape & Size: Pale red colour, stumpy horns, short to medium size, running outwards, upwards and then inwards. Loose skin.''';

      case 'Red Sindhi':
        return '''
Colour: Distinctly red; shades vary from dark red to dim yellow. Patches of white may appear on dewlap or forehead, but no large white patches on the body. In bulls, colour is dark on shoulders and thighs.

Horn Shape & Size: Thick at the base, emerge laterally and curve upward.''';

      case 'Amritmahal':
        return '''
Colour: Grey, but varies from white to almost black. White-grey markings may be present on face and dewlap.

Horn Shape & Size: Long horns, emerging close together from the poll, directed backward and upward, turning inward with sharp black points, sometimes touching each other.

Visible Characteristic: Long head tapering towards muzzle.''';

      case 'Bachaur':
        return '''
Colour: Grey.

Horn Shape & Size: Stumpy, curving outward and upward. Medium in size.

Visible Characteristic: Medium-sized compact animals with straight back. Forehead flat or slightly convex.''';

      case 'Badri':
        return '''
Colour: Small-sized cattle with varied colours – Black, Brown, Red, White or Grey.

Horn Shape & Size: Small horns. Long legs, prominent hump, small udder tucked up with body.

Visible Characteristic: Hooves and muzzle are black or brown. Hump is prominent, udder small and compact.''';

      case 'Bargur':
        return '''
Colour: Brown with white markings.

Horn Shape & Size: Medium-sized, light brown. Horns close at root, inclined backward, outward, upward, with a forward curve, sharp at tip.

Visible Characteristic: Brown coat with white markings, light brown horns.''';

      case 'Belahi':
        return '''
Colour: Red; face, lower abdomen, and feet are white with black muzzle.

Horn Shape & Size: Curved upward and inward, sickle shaped.

Characteristics: Medium-sized, strong dual type, migratory animal of lower Himalayas. White face with some white on hump, neck, and dewlap. In males, hump and neck are dark irrespective of coat colour.''';

      default:
        return 'Detailed information about this cattle breed will be available soon. Please visit the official Pashupedia website for more comprehensive breed information.';
    }
  }

  static List<Map<String, String>> getCattleBreeds() {
    return [
      {
        'title': 'Gir',
        'description': 'Indigenous breed from Gujarat known for high milk yield and disease resistance.',
        'image': 'assets/images/gir_cattle.jpg',
        'yield': '15-20L/day',
      },
      {
        'title': 'Red Sindhi',
        'description': 'Hardy cattle breed known for heat tolerance and good milk production.',
        'image': 'assets/images/Red Sindhi.jpg',
        'yield': '10-15L/day',
      },
      {
        'title': 'Sahiwal',
        'description': 'Heat-resistant breed with excellent milk production in tropical climates.',
        'image': 'assets/images/Sahiwal.jpg',
        'yield': '15-20L/day',
      },
      {
        'title': 'Amritmahal',
        'description': 'Strong, hardy, draft animal, grey-white, low milk.',
        'image': 'assets/images/Amritmahal.jpg',
        'yield': '2-3L/day',
      },
      {
        'title': 'Bachaur',
        'description': 'Indigenous Indian breed, medium-sized, drought-resistant, primarily for milk.',
        'image': 'assets/images/Bachaur.jpg',
        'yield': '6-8L/day',
      },
      {
        'title': 'Badri',
        'description': 'Indigenous Indian breed, hardy, dual-purpose, suited for hot climates.',
        'image': 'assets/images/Badri.jpg',
        'yield': '4-6L/day',
      },
      {
        'title': 'Bargur',
        'description': 'Strong, draught breed from Tamil Nadu, hardy, disease-resistant.',
        'image': 'assets/images/Bargur.jpg',
        'yield': '2-3L/day',
      },
      {
        'title': 'Belahi',
        'description': 'Indigenous breed, hardy, adaptable, primarily used for draft purposes.',
        'image': 'assets/images/Belahi.jpg',
        'yield': '2-4L/day',
      },
    ];
  }
}
