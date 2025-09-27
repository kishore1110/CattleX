import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  const apiKey = 'AIzaSyB3cwg_UOfF5FqkbMEr4NkZsUnZcJ2NPtM';
  
  try {
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
    
    print('Testing Gemini API...');
    
    final content = [Content.text('Hello, can you help with cattle breeds?')];
    final response = await model.generateContent(content);
    
    print('✅ API Key is working!');
    print('Response: ${response.text}');
    
  } catch (e) {
    print('❌ API Key test failed: $e');
  }
}
