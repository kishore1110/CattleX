import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  GenerativeModel? _model;
  bool _isOnline = true;
  bool _modelAvailable = false;

  GeminiService() {
    try {
      // Primary: use the requested Gemini 2.5 Flash model
      _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);
      _modelAvailable = true;
    } catch (e) {
      try {
        _model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: _apiKey);
        _modelAvailable = true;
      } catch (e2) {
        try {
          _model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
          _modelAvailable = true;
        } catch (e3) {
          _modelAvailable = false;
          _updateConnectivity();
          return;
        }
      }
    }
    _updateConnectivity();
  }

  Future<void> _updateConnectivity() async {
    try {
      // In web builds, dart:io lookup is not reliable/available.
      if (kIsWeb) {
        _isOnline =
            true; // Let the actual API call determine connectivity/errors
        return;
      }

      final result = await InternetAddress.lookup(
        'generativelanguage.googleapis.com',
      ).timeout(const Duration(seconds: 5));
      _isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      _isOnline = false;
    } on TimeoutException catch (_) {
      _isOnline = false;
    } catch (e) {
      _isOnline = false;
    }
  }

  Future<String> sendMessage(String message) async {
    try {
      await _updateConnectivity();

      if (!_isOnline) {
        return _getFallbackResponse(message, 'offline');
      }

      if (!_modelAvailable || _model == null) {
        return _getFallbackResponse(message, 'model_error');
      }

      final prompt =
          '''You are a helpful assistant for CattleX specializing in Indian cattle and buffalo breeds.

User question: $message

Instructions:
- For greetings (hi, hello): brief, friendly welcome (2-3 sentences)
- For simple questions: concise answers (3-4 sentences)
- For complex topics: structured but brief responses
- Focus on breed identification, milk yield, feeding, and care tips
- Keep responses conversational and helpful''';

      final content = [Content.text(prompt)];

      final response = await _model!
          .generateContent(content)
          .timeout(const Duration(seconds: 20));

      final responseText = response.text;

      if (responseText != null && responseText.trim().isNotEmpty) {
        return responseText;
      } else {
        return _getFallbackResponse(message, 'no_response');
      }
    } on TimeoutException catch (e) {
      return _getFallbackResponse(message, 'timeout');
    } on SocketException catch (e) {
      return _getFallbackResponse(message, 'network_error');
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('api key not found') ||
          errorString.contains('api_key') ||
          errorString.contains('invalid key') ||
          errorString.contains('invalidapikey')) {
        return _getFallbackResponse(message, 'api_key_error');
      } else if (errorString.contains('not found for api version') ||
          (errorString.contains('model') &&
              errorString.contains('not found'))) {
        return _getFallbackResponse(message, 'model_error');
      } else if (errorString.contains('quota') ||
          errorString.contains('limit')) {
        return _getFallbackResponse(message, 'quota_error');
      } else if (errorString.contains('permission') ||
          errorString.contains('denied')) {
        return _getFallbackResponse(message, 'permission_error');
      } else if (errorString.contains('overloaded') ||
          errorString.contains('503')) {
        return _getFallbackResponse(message, 'overloaded');
      } else if (errorString.contains('unavailable') ||
          errorString.contains('503')) {
        return _getFallbackResponse(message, 'server_unavailable');
      }

      return _getFallbackResponse(message, 'error');
    }
  }

  String _getFallbackResponse(String message, [String? errorType]) {
    String statusMessage = 'experiencing connectivity issues';
    if (errorType == 'offline') {
      statusMessage = 'detected no internet connection';
    } else if (errorType == 'network_error') {
      statusMessage = 'experiencing network connectivity issues';
    } else if (errorType == 'timeout') {
      statusMessage = 'experiencing slow response times';
    } else if (errorType == 'api_key_error') {
      statusMessage =
          'experiencing API key authentication issues. Please check your API key.';
    } else if (errorType == 'quota_error') {
      statusMessage = 'reached API usage limits. Please try again later.';
    } else if (errorType == 'permission_error') {
      statusMessage =
          'experiencing API permission issues. Please check your API settings.';
    } else if (errorType == 'overloaded') {
      statusMessage =
          'temporarily overloaded. The AI service is experiencing high demand. Please try again in a few moments.';
    } else if (errorType == 'server_unavailable') {
      statusMessage =
          'temporarily unavailable due to server maintenance. Please try again later.';
    } else if (errorType == 'model_error') {
      statusMessage =
          'experiencing model compatibility issues. The AI model may not be available.';
    } else if (errorType == 'api_restricted') {
      statusMessage = 'currently unavailable in this region';
    } else if (errorType == 'error') {
      statusMessage = 'encountered an error';
    }

    return '''**CattleX AI Assistant** 🤖

I'm $statusMessage. Here's what you can do:

**Available Information:**
- Browse cattle and buffalo breeds in the **Home** section
- Use the **Scanner** to identify breeds
- Test your knowledge with the **Quiz**
- Visit **Learn More** links for detailed breed information

*Tip: The app's built-in breed database works offline! Try browsing the Home section for detailed information about Indian cattle and buffalo breeds.*''';
  }

  Future<String> askAboutBreed(String breedName) async {
    final message =
        'Tell me about $breedName breed - its characteristics, milk yield, and care tips.';
    return await sendMessage(message);
  }
}
