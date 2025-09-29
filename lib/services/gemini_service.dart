import 'dart:async';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyBxRvHEC92dv7GtRWEFBb1UXa1-JUCYWjE';
  late final GenerativeModel _model;
  bool _isOnline = true;
  
  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash-exp',
      apiKey: _apiKey,
    );
    _updateConnectivity();
  }

  Future<void> _updateConnectivity() async {
    try {
      // Check connectivity to Google's servers (Gemini API host)
      final result = await InternetAddress.lookup('generativelanguage.googleapis.com')
          .timeout(const Duration(seconds: 5));
      _isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      _isOnline = false;
    } on TimeoutException catch (_) {
      _isOnline = false;
    } catch (e) {
      _isOnline = false;
    }
  }

  Future<String> testConnection() async {
    try {
      print('DEBUG: Testing API connection with Gemini 2.0 Flash...');
      await _updateConnectivity();
      
      if (!_isOnline) {
        return 'No internet connection detected';
      }
      
      final content = [Content.text('Say "Hello" in one word.')];
      final response = await _model.generateContent(content)
          .timeout(const Duration(seconds: 10));
      
      final result = response.text ?? 'No response received';
      print('DEBUG: Test connection result: $result');
      return result;
    } on TimeoutException catch (e) {
      print('DEBUG: Test timeout: $e');
      return 'Connection timeout - API is slow to respond';
    } on SocketException catch (e) {
      print('DEBUG: Test network error: $e');
      return 'Network error - Check internet connection';
    } catch (e) {
      print('DEBUG: Test API error: $e');
      return 'API Error: ${e.toString()}';
    }
  }

  Future<String> sendMessage(String message) async {
    try {
      print('DEBUG: Starting sendMessage with: $message');
      
      // Check connectivity first
      await _updateConnectivity();
      print('DEBUG: Connectivity check completed. Online: $_isOnline');
      
      if (!_isOnline) {
        print('DEBUG: No internet connection detected');
        return _getFallbackResponse(message, 'offline');
      }
      
      // Create a simple, direct prompt
      final prompt = '''You are a helpful assistant specializing in Indian cattle and buffalo breeds. 
      
Please answer this question about livestock: $message
      
Keep your response helpful and informative.''';

      final content = [Content.text(prompt)];
      print('DEBUG: Making API call to Gemini...');
      
      // Make API call with timeout
      final response = await _model.generateContent(content)
          .timeout(const Duration(seconds: 20));
      
      print('DEBUG: API call completed');
      final responseText = response.text;
      print('DEBUG: Response text: $responseText');
      
      if (responseText != null && responseText.trim().isNotEmpty) {
        return responseText;
      } else {
        print('DEBUG: Empty response received');
        return _getFallbackResponse(message, 'no_response');
      }
      
    } on TimeoutException catch (e) {
      print('DEBUG: Timeout Exception: $e');
      return _getFallbackResponse(message, 'timeout');
    } on SocketException catch (e) {
      print('DEBUG: Socket Exception: $e');
      return _getFallbackResponse(message, 'network_error');
    } catch (e) {
      print('DEBUG: General Exception: $e');
      print('DEBUG: Exception type: ${e.runtimeType}');
      print('DEBUG: Exception details: ${e.toString()}');
      
      // Check for specific API errors
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('api_key') || errorString.contains('invalid key')) {
        return _getFallbackResponse(message, 'api_key_error');
      } else if (errorString.contains('quota') || errorString.contains('limit')) {
        return _getFallbackResponse(message, 'quota_error');
      } else if (errorString.contains('permission') || errorString.contains('denied')) {
        return _getFallbackResponse(message, 'permission_error');
      } else if (errorString.contains('overloaded') || errorString.contains('503')) {
        return _getFallbackResponse(message, 'overloaded');
      } else if (errorString.contains('unavailable') || errorString.contains('503')) {
        return _getFallbackResponse(message, 'server_unavailable');
      }
      
      return _getFallbackResponse(message, 'error');
    }
  }

  String _getFallbackResponse(String message, [String? errorType]) {
    final lowerMessage = message.toLowerCase();
    
    // Breed-specific responses
    if (lowerMessage.contains('gir')) {
      return '''**Gir Cattle** 🐄

**Characteristics:**
- Origin: Gujarat, India
- Color: Red with white patches, black muzzle
- Horns: Curved upward and inward, sickle-shaped

**Milk Production:**
- Average yield: 15-20 liters/day
- High-quality milk with good fat content

**Care Tips:**
- Heat tolerant breed, suitable for hot climates
- Provide adequate shade and fresh water
- Regular health checkups recommended

*Note: AI service temporarily unavailable. For detailed information, visit the Learn More section.*''';
    }
    
    if (lowerMessage.contains('murrah')) {
      return '''**Murrah Buffalo** 🐃

**Characteristics:**
- Origin: Haryana, India
- Color: Jet black with white markings
- World's best dairy buffalo breed

**Milk Production:**
- Average yield: 18-25 liters/day
- High fat content milk

**Care Tips:**
- Requires good nutrition and clean water
- Regular bathing helps in hot weather
- Excellent for commercial dairy farming

*Note: AI service temporarily unavailable. For detailed information, visit the Learn More section.*''';
    }
    
    // General responses
    if (lowerMessage.contains('milk') && lowerMessage.contains('yield')) {
      return '''**Top Milk Producing Breeds** 🥛

**Cattle:**
1. **Holstein Friesian** - 25-30L/day
2. **Gir** - 15-20L/day
3. **Sahiwal** - 15-20L/day

**Buffalo:**
1. **Nili-Ravi** - 20-28L/day
2. **Murrah** - 18-25L/day
3. **Jaffarabadi** - 12-18L/day

*Note: AI service temporarily unavailable. For detailed breed information, check the breed cards in the Home section.*''';
    }
    
    if (lowerMessage.contains('feed') || lowerMessage.contains('nutrition')) {
      return '''**General Feeding Guidelines** 🌾

**For Cattle & Buffalo:**
- **Green Fodder:** 30-40 kg/day for adult animals
- **Dry Fodder:** 6-8 kg/day
- **Concentrate:** 1 kg per 2.5L of milk production
- **Fresh Water:** 60-80 liters/day

**Seasonal Tips:**
- **Summer:** Increase water intake, provide shade
- **Monsoon:** Ensure dry shelter, quality fodder
- **Winter:** Increase energy-rich feed

*Note: AI service temporarily unavailable. Consult local veterinarian for specific advice.*''';
    }
    
    if (lowerMessage.contains('disease') || lowerMessage.contains('health')) {
      return '''**Common Health Issues & Prevention** 🏥

**Preventive Measures:**
- Regular vaccination schedule
- Clean drinking water
- Proper ventilation in shelters
- Regular health checkups

**Common Issues:**
- **Foot & Mouth Disease** - Vaccination essential
- **Mastitis** - Maintain udder hygiene
- **Parasites** - Regular deworming

**Emergency Signs:**
- Contact veterinarian immediately

*Note: AI service temporarily unavailable. Always consult qualified veterinarian for health issues.*''';
    }
    
    // Default response with more specific guidance
    String statusMessage = 'experiencing connectivity issues';
    
    if (errorType == 'offline') {
      statusMessage = 'detected no internet connection';
    } else if (errorType == 'network_error') {
      statusMessage = 'experiencing network connectivity issues';
    } else if (errorType == 'timeout') {
      statusMessage = 'experiencing slow response times';
    } else if (errorType == 'api_key_error') {
      statusMessage = 'experiencing API key authentication issues. Please check your API key.';
    } else if (errorType == 'quota_error') {
      statusMessage = 'reached API usage limits. Please try again later.';
    } else if (errorType == 'permission_error') {
      statusMessage = 'experiencing API permission issues. Please check your API settings.';
    } else if (errorType == 'overloaded') {
      statusMessage = 'temporarily overloaded. The AI service is experiencing high demand. Please try again in a few moments.';
    } else if (errorType == 'server_unavailable') {
      statusMessage = 'temporarily unavailable due to server maintenance. Please try again later.';
    } else if (errorType == 'api_restricted') {
      statusMessage = 'currently unavailable in this region';
    } else if (errorType == 'error') {
      statusMessage = 'encountered an error';
    }
    
    return '''**CattleX AI Assistant** 🤖

I'm ${statusMessage}. Here's what you can do:

**Available Information:**
- Browse cattle and buffalo breeds in the **Home** section
- Use the **Scanner** to identify breeds
- Test your knowledge with the **Quiz**
- Visit **Learn More** links for detailed breed information

**Quick Answers:**
${_getBreedInfo(message)}

*Tip: The app's built-in breed database works offline! Try browsing the Home section for detailed information about Indian cattle and buffalo breeds.*''';
  }

  Future<String> askAboutBreed(String breedName) async {
    final message = 'Tell me about $breedName breed - its characteristics, milk yield, and care tips.';
    return await sendMessage(message);
  }

  String _getBreedInfo(String message) {
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('gir')) {
      return '• **Gir Cattle**: Originates from Gujarat, known for high milk yield (15-20L/day) and heat tolerance.';
    } else if (lowerMessage.contains('murrah')) {
      return '• **Murrah Buffalo**: Premium dairy breed from Haryana, produces 18-25L/day with high fat content.';
    } else if (lowerMessage.contains('milk') && lowerMessage.contains('yield')) {
      return '• **Top Milk Yields**:\n   - Murrah Buffalo: 18-25L/day\n   - Gir Cattle: 15-20L/day\n   - Sahiwal: 12-18L/day';
    } else if (lowerMessage.contains('feed') || lowerMessage.contains('food')) {
      return '• **Feeding Guide**:\n   - Green fodder: 30-40kg/day\n   - Dry fodder: 6-8kg/day\n   - Concentrate: 1kg per 2.5L milk';
    } else if (lowerMessage.contains('sahiwal')) {
      return '• **Sahiwal Cattle**: Dual-purpose breed from Punjab, produces 12-18L/day, heat and tick resistant.';
    } else if (lowerMessage.contains('amritmahal')) {
      return '• **Amritmahal**: Draught breed from Karnataka, known for strength and endurance in hot climates.';
    } else if (lowerMessage.contains('nili') || lowerMessage.contains('ravi')) {
      return '• **Nili-Ravi Buffalo**: From Punjab, produces 20-28L/day, known as "Black Gold" of Pakistan.';
    }
    
    return '';
  }
}
