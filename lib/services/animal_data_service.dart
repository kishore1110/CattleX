import 'package:cloud_firestore/cloud_firestore.dart';

class AnimalDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  /// Save animal data to Firebase with hierarchical structure
  /// Collection: cattle/buffalo -> breed_name -> animal_documents
  Future<void> saveAnimalData({
    required String animalId,
    required String breedName,
    required double confidence,
    required double latitude,
    required double longitude,
    required DateTime dateTime,
    required List<Map<String, dynamic>> vaccinations,
  }) async {
    try {
      // Determine animal type (cattle or buffalo) based on breed
      String animalType = _getAnimalType(breedName);
      
      // Convert breed name to collection-friendly format
      String breedCollection = _formatBreedName(breedName);
      
      // Create the document data
      Map<String, dynamic> animalData = {
        'id': animalId,
        'breedName': breedName,
        'confidence': confidence,
        'location': {
          'latitude': latitude,
          'longitude': longitude,
        },
        'dateTime': Timestamp.fromDate(dateTime),
        'vaccinations': vaccinations.map((vaccination) => {
          'type': vaccination['vaccination'],
          'date': vaccination['date'] != null 
              ? Timestamp.fromDate(vaccination['date']) 
              : null,
        }).where((v) => v['type'] != null && v['date'] != null).toList(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Save to hierarchical structure: animalType/breedCollection/animalId
      await _firestore
          .collection(animalType)
          .doc(breedCollection)
          .collection('animals')
          .doc(animalId)
          .set(animalData);

      print('Animal data saved successfully: $animalType/$breedCollection/$animalId');
    } catch (e) {
      print('Error saving animal data: $e');
      throw Exception('Failed to save animal data: $e');
    }
  }

  /// Get all animals for a specific breed
  Future<List<Map<String, dynamic>>> getAnimalsByBreed({
    required String breedName,
  }) async {
    try {
      String animalType = _getAnimalType(breedName);
      String breedCollection = _formatBreedName(breedName);

      QuerySnapshot snapshot = await _firestore
          .collection(animalType)
          .doc(breedCollection)
          .collection('animals')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['documentId'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching animals by breed: $e');
      return [];
    }
  }

  /// Get all animals (from all breeds)
  Future<List<Map<String, dynamic>>> getAllAnimals() async {
    try {
      List<Map<String, dynamic>> allAnimals = [];

      // Get all cattle breeds
      for (String breedName in _getAllCattleBreeds()) {
        List<Map<String, dynamic>> breedAnimals = await getAnimalsByBreed(breedName: breedName);
        allAnimals.addAll(breedAnimals);
      }

      // Get all buffalo breeds
      for (String breedName in _getAllBuffaloBreeds()) {
        List<Map<String, dynamic>> breedAnimals = await getAnimalsByBreed(breedName: breedName);
        allAnimals.addAll(breedAnimals);
      }

      // Sort by creation date
      allAnimals.sort((a, b) {
        Timestamp aTime = a['createdAt'] ?? Timestamp.now();
        Timestamp bTime = b['createdAt'] ?? Timestamp.now();
        return bTime.compareTo(aTime);
      });

      return allAnimals;
    } catch (e) {
      print('Error fetching all animals: $e');
      return [];
    }
  }

  /// Determine if breed is cattle or buffalo
  String _getAnimalType(String breedName) {
    List<String> cattleBreeds = _getAllCattleBreeds();
    List<String> buffaloBreeds = _getAllBuffaloBreeds();

    if (cattleBreeds.contains(breedName)) {
      return 'cattle';
    } else if (buffaloBreeds.contains(breedName)) {
      return 'buffalo';
    } else {
      // Default to cattle if breed not found
      return 'cattle';
    }
  }

  /// Format breed name for Firestore collection (lowercase, replace spaces with underscores)
  String _formatBreedName(String breedName) {
    return breedName
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('-', '_');
  }

  /// Get all cattle breed names
  List<String> _getAllCattleBreeds() {
    return [
      'Holstein Friesian',
      'Jersey',
      'Gir',
      'Sahiwal',
      'Red Sindhi',
      'Tharparkar',
      'Rathi',
      'Hariana',
      'Ongole',
      'Krishna Valley',
      'Deoni',
      'Khillari',
      'Malvi',
      'Nimari',
      'Nagori',
      'Kankrej',
      'Hallikar',
      'Amritmahal',
      'Bargur',
      'Pulikulam',
      'Umbalachery',
      'Vechur',
      'Kasaragod',
      'Punganur',
    ];
  }

  /// Get all buffalo breed names
  List<String> _getAllBuffaloBreeds() {
    return [
      'Murrah',
      'Nili Ravi',
      'Surti',
      'Jaffarabadi',
      'Mehsana',
      'Bhadawari',
      'Nagpuri',
      'Pandharpuri',
      'Kalahandi',
      'Sambalpuri',
      'Chilika',
      'Manda',
    ];
  }
}
