import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class CattleDetector {
  /// Detect cattle breed using the hosted FastAPI backend
  Future<DetectionResult> detectCattle(XFile imageFile) async {
    try {
      final apiUrl = dotenv.env['CATTLE_API_URL'] ?? '';
      var uri = Uri.parse(apiUrl);
      var request = http.MultipartRequest('POST', uri);

      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes('file', bytes, filename: imageFile.name),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath('file', imageFile.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          return DetectionResult(
            isAnimal: true,
            animalType: AnimalType.cattle,
            confidence: responseData['confidence']?.toDouble() ?? 0.0,
            message: responseData['breed'] ?? 'Unknown Breed',
          );
        } else {
          return DetectionResult(
            isAnimal: false,
            animalType: AnimalType.none,
            confidence: 0.0,
            message: responseData['message'] ?? 'Failed to detect cattle',
          );
        }
      } else {
        return DetectionResult(
          isAnimal: false,
          animalType: AnimalType.none,
          confidence: 0.0,
          message: 'Server error: ${response.statusCode}',
        );
      }
    } on SocketException catch (_) {
      return DetectionResult(
        isAnimal: false,
        animalType: AnimalType.none,
        confidence: 0.0,
        message:
            'No internet connection. Please connect to the internet or refer to locally stored breed information on the Home screen.',
      );
    } catch (e) {
      return DetectionResult(
        isAnimal: false,
        animalType: AnimalType.none,
        confidence: 0.0,
        message: 'Detection failed: $e',
      );
    }
  }
}

/// Animal types that can be detected
enum AnimalType { none, cattle, buffalo }

/// Detection result class
class DetectionResult {
  final bool isAnimal;
  final AnimalType animalType;
  final double confidence;
  final String message;

  DetectionResult({
    required this.isAnimal,
    required this.animalType,
    required this.confidence,
    required this.message,
  });

  @override
  String toString() {
    return 'DetectionResult(isAnimal: $isAnimal, animalType: $animalType, confidence: $confidence, message: $message)';
  }
}
