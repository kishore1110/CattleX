import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  const apiKey = 'AIzaSyAhhq6kYcCRkrkTwU23m8vN39w8j8-WNWs';
  
  print('🔍 Testing Gemini API connection...');
  
  try {
    // Test 1: Basic connection
    print('\n🚀 Testing basic connection...');
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
    
    // Test 2: Simple request
    print('\n📡 Sending test request...');
    final response = await model.generateContent([
      Content.text('Hello, can you tell me about Gir cattle breed?')
    ]);
    
    print('\n✅ Success! API is working.');
    print('\n📝 Response:');
    print(response.text);
    
  } catch (e) {
    print('\n❌ Error occurred:');
    print(e.toString());
    
    // Check internet connection
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('\n🌐 Internet connection is working.');
        print('\n🔑 Possible issues:');
        print('1. API key might be invalid or expired');
        print('2. Gemini API might not be available in your region');
        print('3. API key might have usage restrictions');
      }
    } on SocketException catch (_) {
      print('\n⚠️ No internet connection detected');
    }
  }
}
