import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../main.dart';

class TestGeminiScreen extends StatefulWidget {
  const TestGeminiScreen({super.key});

  @override
  State<TestGeminiScreen> createState() => _TestGeminiScreenState();
}

class _TestGeminiScreenState extends State<TestGeminiScreen> {
  final GeminiService _geminiService = GeminiService();
  String _testResult = 'Testing API connection...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _testApiKey();
  }

  Future<void> _testApiKey() async {
    setState(() {
      _isLoading = true;
      _testResult = 'Testing Gemini API connection...';
    });

    try {
      final result = await _geminiService.testConnection();
      setState(() {
        _testResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _testResult = 'Error testing API: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini API Test'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'API Key Test Results:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            if (_isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                    SizedBox(height: 16),
                    Text('Testing connection...'),
                  ],
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                  color: _testResult.startsWith('Error') 
                    ? Colors.red.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
                ),
                child: Text(
                  _testResult,
                  style: TextStyle(
                    fontSize: 14,
                    color: _testResult.startsWith('Error') 
                      ? Colors.red.shade700
                      : Colors.green.shade700,
                  ),
                ),
              ),
            
            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _testApiKey,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Test Again'),
              ),
            ),
            
            const SizedBox(height: 20),
            
            if (!_isLoading && !_testResult.startsWith('Error'))
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✅ API Key is Working!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'The Gemini API key is valid and responsive. Ready to integrate the chatbot!',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
