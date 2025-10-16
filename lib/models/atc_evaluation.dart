class ATCEvaluation {
  final String animalId;
  final String breed;
  final ATCMeasurements evaluation;
  final double overallATCScore;
  final double confidence;
  final ATCMetadata metadata;

  ATCEvaluation({
    required this.animalId,
    required this.breed,
    required this.evaluation,
    required this.overallATCScore,
    required this.confidence,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'animal_id': animalId,
      'breed': breed,
      'evaluation': evaluation.toJson(),
      'overall_ATC_score': overallATCScore,
      'confidence': confidence,
      'metadata': metadata.toJson(),
    };
  }

  factory ATCEvaluation.fromJson(Map<String, dynamic> json) {
    return ATCEvaluation(
      animalId: json['animal_id'] ?? '',
      breed: json['breed'] ?? '',
      evaluation: ATCMeasurements.fromJson(json['evaluation'] ?? {}),
      overallATCScore: (json['overall_ATC_score'] ?? 0.0).toDouble(),
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      metadata: ATCMetadata.fromJson(json['metadata'] ?? {}),
    );
  }
}

class ATCMeasurements {
  final ATCParameter height;
  final ATCParameter bodyLength;
  final ATCParameter chestWidth;
  final ATCParameter chestDepth;
  final ATCParameter rumpAngle;
  final ATCParameter rumpWidth;
  final ATCScoreOnly topline;
  final ATCScoreOnly legsFeet;
  final ATCParameter bcs; // Body Condition Score

  ATCMeasurements({
    required this.height,
    required this.bodyLength,
    required this.chestWidth,
    required this.chestDepth,
    required this.rumpAngle,
    required this.rumpWidth,
    required this.topline,
    required this.legsFeet,
    required this.bcs,
  });

  Map<String, dynamic> toJson() {
    return {
      'height': height.toJson(),
      'body_length': bodyLength.toJson(),
      'chest_width': chestWidth.toJson(),
      'chest_depth': chestDepth.toJson(),
      'rump_angle': rumpAngle.toJsonWithDegrees(),
      'rump_width': rumpWidth.toJson(),
      'topline': topline.toJson(),
      'legs_feet': legsFeet.toJson(),
      'BCS': bcs.toJsonWithValue(),
    };
  }

  factory ATCMeasurements.fromJson(Map<String, dynamic> json) {
    return ATCMeasurements(
      height: ATCParameter.fromJson(json['height'] ?? {}),
      bodyLength: ATCParameter.fromJson(json['body_length'] ?? {}),
      chestWidth: ATCParameter.fromJson(json['chest_width'] ?? {}),
      chestDepth: ATCParameter.fromJson(json['chest_depth'] ?? {}),
      rumpAngle: ATCParameter.fromJsonWithDegrees(json['rump_angle'] ?? {}),
      rumpWidth: ATCParameter.fromJson(json['rump_width'] ?? {}),
      topline: ATCScoreOnly.fromJson(json['topline'] ?? {}),
      legsFeet: ATCScoreOnly.fromJson(json['legs_feet'] ?? {}),
      bcs: ATCParameter.fromJsonWithValue(json['BCS'] ?? {}),
    );
  }
}

class ATCParameter {
  final double valueCm;
  final int score;

  ATCParameter({
    required this.valueCm,
    required this.score,
  });

  Map<String, dynamic> toJson() {
    return {
      'value_cm': valueCm,
      'score': score,
    };
  }

  Map<String, dynamic> toJsonWithDegrees() {
    return {
      'value_deg': valueCm,
      'score': score,
    };
  }

  Map<String, dynamic> toJsonWithValue() {
    return {
      'value': valueCm,
      'score': score,
    };
  }

  factory ATCParameter.fromJson(Map<String, dynamic> json) {
    return ATCParameter(
      valueCm: (json['value_cm'] ?? 0.0).toDouble(),
      score: json['score'] ?? 1,
    );
  }

  factory ATCParameter.fromJsonWithDegrees(Map<String, dynamic> json) {
    return ATCParameter(
      valueCm: (json['value_deg'] ?? 0.0).toDouble(),
      score: json['score'] ?? 1,
    );
  }

  factory ATCParameter.fromJsonWithValue(Map<String, dynamic> json) {
    return ATCParameter(
      valueCm: (json['value'] ?? 0.0).toDouble(),
      score: json['score'] ?? 1,
    );
  }
}

class ATCScoreOnly {
  final int score;

  ATCScoreOnly({required this.score});

  Map<String, dynamic> toJson() {
    return {
      'score': score,
    };
  }

  factory ATCScoreOnly.fromJson(Map<String, dynamic> json) {
    return ATCScoreOnly(
      score: json['score'] ?? 1,
    );
  }
}

class ATCMetadata {
  final DateTime timestamp;
  final ATCGPSLocation gps;

  ATCMetadata({
    required this.timestamp,
    required this.gps,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'gps': gps.toJson(),
    };
  }

  factory ATCMetadata.fromJson(Map<String, dynamic> json) {
    return ATCMetadata(
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      gps: ATCGPSLocation.fromJson(json['gps'] ?? {}),
    );
  }
}

class ATCGPSLocation {
  final double latitude;
  final double longitude;

  ATCGPSLocation({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory ATCGPSLocation.fromJson(Map<String, dynamic> json) {
    return ATCGPSLocation(
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }
}

// Helper class for generating mock ATC data
class ATCDataGenerator {
  static ATCEvaluation generateMockEvaluation(String animalId, String breed, double latitude, double longitude) {
    // Generate realistic ATC scores based on breed standards
    final breedStandards = _getBreedStandards(breed);
    
    return ATCEvaluation(
      animalId: animalId,
      breed: breed,
      evaluation: ATCMeasurements(
        height: ATCParameter(
          valueCm: breedStandards['height']! + _randomVariation(5.0),
          score: _generateScore(7, 2),
        ),
        bodyLength: ATCParameter(
          valueCm: breedStandards['bodyLength']! + _randomVariation(8.0),
          score: _generateScore(6, 2),
        ),
        chestWidth: ATCParameter(
          valueCm: breedStandards['chestWidth']! + _randomVariation(3.0),
          score: _generateScore(7, 1),
        ),
        chestDepth: ATCParameter(
          valueCm: breedStandards['chestDepth']! + _randomVariation(4.0),
          score: _generateScore(6, 2),
        ),
        rumpAngle: ATCParameter(
          valueCm: breedStandards['rumpAngle']! + _randomVariation(2.0),
          score: _generateScore(7, 1),
        ),
        rumpWidth: ATCParameter(
          valueCm: breedStandards['rumpWidth']! + _randomVariation(3.0),
          score: _generateScore(6, 2),
        ),
        topline: ATCScoreOnly(score: _generateScore(7, 1)),
        legsFeet: ATCScoreOnly(score: _generateScore(6, 2)),
        bcs: ATCParameter(
          valueCm: 3.5 + _randomVariation(0.5),
          score: _generateScore(7, 1),
        ),
      ),
      overallATCScore: 6.8 + _randomVariation(1.2),
      confidence: 0.85 + _randomVariation(0.10),
      metadata: ATCMetadata(
        timestamp: DateTime.now(),
        gps: ATCGPSLocation(
          latitude: latitude,
          longitude: longitude,
        ),
      ),
    );
  }

  static Map<String, double> _getBreedStandards(String breed) {
    // Standard measurements for different breeds (in cm and degrees)
    switch (breed.toLowerCase()) {
      case 'gir':
        return {
          'height': 120.0,
          'bodyLength': 135.0,
          'chestWidth': 46.0,
          'chestDepth': 70.0,
          'rumpAngle': 14.0,
          'rumpWidth': 46.0,
        };
      case 'sahiwal':
        return {
          'height': 128.0,
          'bodyLength': 131.0,
          'chestWidth': 50.0,
          'chestDepth': 74.0,
          'rumpAngle': 13.0,
          'rumpWidth': 48.0,
        };
      case 'lakhimi':
        return {
          'height': 110.0,
          'bodyLength': 115.0,
          'chestWidth': 42.0,
          'chestDepth': 60.0,
          'rumpAngle': 20.0,
          'rumpWidth': 42.0,
        };
      case 'murrah':
        return {
          'height': 135.0,
          'bodyLength': 145.0,
          'chestWidth': 52.0,
          'chestDepth': 78.0,
          'rumpAngle': 12.0,
          'rumpWidth': 52.0,
        };
      default:
        return {
          'height': 120.0,
          'bodyLength': 130.0,
          'chestWidth': 46.0,
          'chestDepth': 70.0,
          'rumpAngle': 15.0,
          'rumpWidth': 46.0,
        };
    }
  }

  static double _randomVariation(double range) {
    return (DateTime.now().millisecondsSinceEpoch % 1000 / 1000.0 - 0.5) * 2 * range;
  }

  static int _generateScore(int base, int variation) {
    final random = DateTime.now().millisecondsSinceEpoch % 10;
    final score = base + (random % (variation * 2 + 1)) - variation;
    return score.clamp(1, 9);
  }
}
