import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // TODO: Move API key to environment variables or secure storage
  // IMPORTANT: Replace this with your upgraded plan API key
  static const String _apiKey = 'AIzaSyD4ewmkneZwxNKbbO7Suf7u-bs871tEIUo';
  late final GenerativeModel _primaryModel;
  late final GenerativeModel _fallbackModel;
  late final GenerativeModel _lastResortModel;
  bool _isOnline = true;
  int _modelIndex = 0; // 0: primary, 1: fallback, 2: last resort
  
  GeminiService() {
    _initializeModels();
  }

  Future<void> _initializeModels() async {
    try {
      print('DEBUG: Checking available models...');
      final availableModels = await listAvailableModels();
      
      String primaryModelName = 'gemini-1.5-flash-latest';
      String fallbackModelName = 'gemini-1.5-pro-latest';
      
      // Use the first available model that supports generateContent
      if (availableModels.isNotEmpty) {
        // Prefer newer models if available
        if (availableModels.contains('gemini-1.5-flash-latest')) {
          primaryModelName = 'gemini-1.5-flash-latest';
        } else if (availableModels.contains('gemini-1.5-pro-latest')) {
          primaryModelName = 'gemini-1.5-pro-latest';
        } else if (availableModels.contains('gemini-1.5-flash')) {
          primaryModelName = 'gemini-1.5-flash';
        } else if (availableModels.contains('gemini-1.5-pro')) {
          primaryModelName = 'gemini-1.5-pro';
        } else if (availableModels.contains('gemini-pro')) {
          primaryModelName = 'gemini-pro';
        } else {
          primaryModelName = availableModels.first;
        }
        
        fallbackModelName = availableModels.length > 1 ? availableModels[1] : availableModels.first;
      }
      
      print('DEBUG: Using primary model: $primaryModelName');
      print('DEBUG: Using fallback model: $fallbackModelName');
      
      _primaryModel = GenerativeModel(
        model: primaryModelName,
        apiKey: _apiKey,
      );
      _fallbackModel = GenerativeModel(
        model: fallbackModelName,
        apiKey: _apiKey,
      );
      _lastResortModel = GenerativeModel(
        model: fallbackModelName,
        apiKey: _apiKey,
      );
      
      print('DEBUG: GeminiService initialized successfully');
      _updateConnectivity();
    } catch (e) {
      print('DEBUG: Failed to initialize GeminiService: $e');
      _isOnline = false;
      
      // Fallback to basic initialization
      try {
        _primaryModel = GenerativeModel(
          model: 'gemini-pro',
          apiKey: _apiKey,
        );
        _fallbackModel = GenerativeModel(
          model: 'gemini-pro',
          apiKey: _apiKey,
        );
        _lastResortModel = GenerativeModel(
          model: 'gemini-pro',
          apiKey: _apiKey,
        );
        print('DEBUG: Fallback initialization completed');
      } catch (fallbackError) {
        print('DEBUG: Even fallback initialization failed: $fallbackError');
      }
    }
  }

  void resetToWorkingModel() {
    print('DEBUG: Resetting to Gemini 1.5 Pro (known working model)');
    _modelIndex = 1;
  }

  Future<List<String>> listAvailableModels() async {
    try {
      final url = 'https://generativelanguage.googleapis.com/v1beta/models?key=$_apiKey';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final models = <String>[];
        
        if (data['models'] != null) {
          for (final model in data['models']) {
            if (model['name'] != null && 
                model['supportedGenerationMethods'] != null &&
                model['supportedGenerationMethods'].contains('generateContent')) {
              models.add(model['name'].toString().replaceFirst('models/', ''));
            }
          }
        }
        print('DEBUG: Available models: $models');
        return models;
      } else {
        print('DEBUG: Failed to list models: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('DEBUG: Error listing models: $e');
      return [];
    }
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
      print('DEBUG: Testing API connection...');
      print('DEBUG: API Key (first 10 chars): ${_apiKey.substring(0, 10)}...');
      
      // First, list available models
      final availableModels = await listAvailableModels();
      if (availableModels.isEmpty) {
        return '❌ **No Models Available**\n\nYour API key doesn\'t have access to any Gemini models.\n\nPlease check:\n- API key validity\n- Account permissions\n- Billing status';
      }
      
      await _updateConnectivity();
      
      if (!_isOnline) {
        print('DEBUG: No internet connection detected');
        return '🌐 **No Internet Connection**\n\nPlease check your internet connection and try again.';
      }
      
      final content = [Content.text('Hello, can you respond with a simple greeting?')];
      print('DEBUG: Making test API call with available model...');
      final response = await _primaryModel.generateContent(content)
          .timeout(const Duration(seconds: 15));
      
      final result = response.text ?? 'No response received';
      print('DEBUG: Test connection SUCCESS: $result');
      return '✅ **Connection Test Successful!**\n\nAPI is working properly.\n\n**Available Models:** ${availableModels.join(', ')}\n\n**Response:** $result';
    } on TimeoutException catch (e) {
      print('DEBUG: Test timeout: $e');
      return '⏱️ **Connection Timeout**\n\nThe API is slow to respond. This might be due to:\n- High server load\n- Network issues\n- Model availability';
    } on SocketException catch (e) {
      print('DEBUG: Test network error: $e');
      return '🌐 **Network Error**\n\nCheck your internet connection.\n\nError: ${e.message}';
    } catch (e) {
      print('DEBUG: Test API error: $e');
      print('DEBUG: Error type: ${e.runtimeType}');
      
      final errorStr = e.toString();
      if (errorStr.contains('404') || errorStr.contains('not found')) {
        return '❌ **Model Not Found**\n\nGemini 1.5 Flash may not be available with your API key.\n\nTry:\n- Check if you have access to this model\n- Verify API key permissions';
      } else if (errorStr.contains('403') || errorStr.contains('forbidden')) {
        return '🚫 **Access Denied**\n\nYour API key may not have access to this model.\n\nError: $errorStr';
      } else if (errorStr.contains('401') || errorStr.contains('unauthorized')) {
        return '🔑 **Authentication Error**\n\nAPI key may be invalid or expired.\n\nError: $errorStr';
      }
      
      return '⚠️ **API Error**\n\nUnexpected error occurred:\n\n$errorStr';
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
      final prompt = '''You are a helpful assistant specializing in Indian cattle and buffalo breeds. Answer this question: $message''';

      final content = [Content.text(prompt)];
      print('DEBUG: Making API call to Gemini...');
      
      // Make API call with timeout - select model based on index
      GenerativeModel currentModel;
      String modelName;
      
      switch (_modelIndex) {
        case 0:
          currentModel = _primaryModel;
          modelName = 'Gemini Pro';
          break;
        case 1:
          currentModel = _fallbackModel;
          modelName = 'Gemini Pro (Fallback)';
          break;
        case 2:
          currentModel = _lastResortModel;
          modelName = 'Gemini Pro (Last Resort)';
          break;
        default:
          currentModel = _primaryModel;
          modelName = 'Gemini Pro';
      }
      
      print('DEBUG: Using model: $modelName (index: $_modelIndex)');
      
      final response = await currentModel.generateContent(content)
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
      if (errorString.contains('unhandled format for promptfeedback') || errorString.contains('generativeaisdkexception')) {
        // Try next model if available
        if (_modelIndex < 1) {
          print('DEBUG: SDK compatibility issue detected, switching to Gemini 1.5 Pro');
          _modelIndex = 1;
          return await sendMessage(message); // Retry with next model
        }
        return _getFallbackResponse(message, 'sdk_compatibility');
      } else if (errorString.contains('api_key') || errorString.contains('invalid key') || errorString.contains('authentication')) {
        return _getFallbackResponse(message, 'api_key_error');
      } else if (errorString.contains('quota') || errorString.contains('limit') || errorString.contains('exceeded')) {
        if (errorString.contains('free_tier')) {
          return '''🚫 **Free Tier Quota Exceeded**

Your Google AI API free tier quota has been exceeded.

**Solutions:**
1. **Wait**: Free tier resets daily (usually midnight UTC)
2. **New API Key**: Create a fresh key at ai.google.dev
3. **Upgrade**: Enable billing for higher limits

**Current Status**: Please try again later or use a different API key.

*Note: The app's offline breed database still works! Check the Home section for detailed breed information.*''';
        }
        return _getFallbackResponse(message, 'quota_error');
      } else if (errorString.contains('permission') || errorString.contains('denied') || errorString.contains('forbidden')) {
        return _getFallbackResponse(message, 'permission_error');
      } else if (errorString.contains('model') || errorString.contains('not found') || errorString.contains('invalid model') || errorString.contains('is not found for api version')) {
        // Try Gemini 1.5 Pro if we haven't already
        if (_modelIndex == 0) {
          print('DEBUG: Model not found, switching to Gemini 1.5 Pro');
          _modelIndex = 1;
          return await sendMessage(message); // Retry with next model
        }
        return _getFallbackResponse(message, 'model_error');
      } else if (errorString.contains('overloaded') || errorString.contains('503') || errorString.contains('service unavailable')) {
        return _getFallbackResponse(message, 'overloaded');
      } else if (errorString.contains('unavailable') || errorString.contains('502') || errorString.contains('bad gateway')) {
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
    } else if (errorType == 'model_error') {
      statusMessage = 'experiencing model compatibility issues. The AI model may not be available.';
    } else if (errorType == 'sdk_compatibility') {
      statusMessage = 'automatically switched to a compatible model due to SDK compatibility issues.';
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
