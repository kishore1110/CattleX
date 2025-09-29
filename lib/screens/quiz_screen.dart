import 'package:flutter/material.dart';
import '../main.dart';
import '../data/cattle_breeds.dart';
import '../data/buffalo_breeds.dart';
import 'dart:math';

enum QuizMode { imageBasedMCQ, textBasedMCQ, reverseQuiz }

enum QuizTheme {
  cattleOnly,
  buffaloOnly,
  milkProducers,
  draftAnimals,
  mixedBreeds,
  regionalFocus,
  allBreeds,
}

enum DifficultyLevel { easy, medium, hard }

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  QuizMode? _selectedMode;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  List<int?> _selectedAnswers = [];
  final List<Map<String, dynamic>> _questions = [];

  // Combined breed data
  List<Map<String, String>> get _allBreeds {
    return [
      ...CattleBreeds.getCattleBreeds(),
      ...BuffaloBreeds.getBuffaloBreeds(),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  void _selectQuizMode(QuizMode mode) {
    setState(() {
      _selectedMode = mode;
      _generateQuestions();
      _selectedAnswers = List.filled(_questions.length, null);
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
    });
  }

  // Daily Quiz Generation System
  int _getDailySeed() {
    final now = DateTime.now();
    return now.year * 10000 + now.month * 100 + now.day;
  }

  QuizTheme _getDailyTheme() {
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    final themes = QuizTheme.values;
    return themes[dayOfYear % themes.length];
  }

  DifficultyLevel _getDailyDifficulty() {
    final dayOfMonth = DateTime.now().day;
    if (dayOfMonth <= 10) return DifficultyLevel.easy;
    if (dayOfMonth <= 20) return DifficultyLevel.medium;
    return DifficultyLevel.hard;
  }

  List<QuizMode> _getDailyModes(Random random) {
    final modes = QuizMode.values.toList()..shuffle(random);
    return modes; // Use all modes in random order
  }

  List<Map<String, String>> _getBreedsForTheme(QuizTheme theme) {
    switch (theme) {
      case QuizTheme.cattleOnly:
        return CattleBreeds.getCattleBreeds();
      case QuizTheme.buffaloOnly:
        return BuffaloBreeds.getBuffaloBreeds();
      case QuizTheme.milkProducers:
        return _allBreeds.where((breed) {
          final yield = breed['yield']!.toLowerCase();
          return yield.contains('15') ||
              yield.contains('20') ||
              yield.contains('18') ||
              yield.contains('12');
        }).toList();
      case QuizTheme.draftAnimals:
        return _allBreeds.where((breed) {
          final description = breed['description']!.toLowerCase();
          return description.contains('draft') ||
              description.contains('draught') ||
              description.contains('work') ||
              description.contains('plough');
        }).toList();
      case QuizTheme.regionalFocus:
        return _allBreeds.where((breed) {
          final description = breed['description']!.toLowerCase();
          return description.contains('gujarat') ||
              description.contains('punjab') ||
              description.contains('rajasthan') ||
              description.contains('maharashtra');
        }).toList();
      case QuizTheme.mixedBreeds:
        final cattle = CattleBreeds.getCattleBreeds().take(3).toList();
        final buffalo = BuffaloBreeds.getBuffaloBreeds().take(2).toList();
        return [...cattle, ...buffalo];
      case QuizTheme.allBreeds:
        return _allBreeds;
    }
  }

  List<Map<String, String>> _filterByDifficulty(
    List<Map<String, String>> breeds,
    DifficultyLevel difficulty,
  ) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        // Popular, well-known breeds
        return breeds.where((breed) {
          final title = breed['title']!.toLowerCase();
          return [
            'gir',
            'sahiwal',
            'red sindhi',
            'murrah',
            'banni',
          ].any((popular) => title.contains(popular));
        }).toList();
      case DifficultyLevel.medium:
        // Mix of common and less common breeds
        return breeds.length > 10
            ? breeds.sublist(0, (breeds.length * 0.7).round())
            : breeds;
      case DifficultyLevel.hard:
        // All breeds including rare ones
        return breeds;
    }
  }

  void _generateQuestions() {
    _questions.clear();

    // Get daily parameters
    final dailySeed = _getDailySeed();
    final dailyRandom = Random(dailySeed);
    final theme = _getDailyTheme();
    final difficulty = _getDailyDifficulty();
    final modes = _getDailyModes(dailyRandom);

    // Get themed and filtered breeds
    final themedBreeds = _getBreedsForTheme(theme);
    final availableBreeds = _filterByDifficulty(themedBreeds, difficulty);

    // Ensure we have enough breeds
    final breedsToUse = availableBreeds.isNotEmpty
        ? availableBreeds
        : _allBreeds;
    final shuffledBreeds = List<Map<String, String>>.from(breedsToUse)
      ..shuffle(dailyRandom);
    final selectedBreeds = shuffledBreeds.take(5).toList();

    for (int i = 0; i < selectedBreeds.length; i++) {
      final correctBreed = selectedBreeds[i];
      final wrongOptions =
          breedsToUse
              .where((breed) => breed['title'] != correctBreed['title'])
              .toList()
            ..shuffle(dailyRandom);
      final options = [correctBreed, ...wrongOptions.take(3)].toList()
        ..shuffle(dailyRandom);
      final correctIndex = options.indexOf(correctBreed);

      // Use different modes for variety (cycle through available modes)
      final questionMode = _selectedMode ?? modes[i % modes.length];

      switch (questionMode) {
        case QuizMode.imageBasedMCQ:
          _questions.add({
            'type': 'image',
            'image': correctBreed['image']!,
            'question': 'Which breed is shown in this image?',
            'options': options.map((breed) => breed['title']!).toList(),
            'correctAnswer': correctIndex,
            'explanation':
                'This is ${correctBreed['title']}: ${correctBreed['description']}',
          });
          break;

        case QuizMode.textBasedMCQ:
          final description = _getBreedCharacteristics(correctBreed['title']!);
          _questions.add({
            'type': 'text',
            'question':
                'Based on these characteristics: $description\n\nWhich breed matches this description?',
            'options': options.map((breed) => breed['title']!).toList(),
            'correctAnswer': correctIndex,
            'explanation':
                'The correct answer is ${correctBreed['title']}: ${correctBreed['description']}',
          });
          break;

        case QuizMode.reverseQuiz:
          _questions.add({
            'type': 'reverse',
            'question':
                'Select the correct image for: ${correctBreed['title']}',
            'breedName': correctBreed['title']!,
            'options': options.map((breed) => breed['image']!).toList(),
            'optionTitles': options.map((breed) => breed['title']!).toList(),
            'correctAnswer': correctIndex,
            'explanation':
                '${correctBreed['title']}: ${correctBreed['description']}',
          });
          break;
      }
    }
  }

  String _getBreedCharacteristics(String breedName) {
    final cattleDescription = CattleBreeds.getDetailedDescription(breedName);
    final buffaloDescription = BuffaloBreeds.getDetailedDescription(breedName);

    String fullDescription = cattleDescription.contains('Detailed information')
        ? buffaloDescription
        : cattleDescription;

    // Extract key characteristics
    final lines = fullDescription.split('\n');
    String characteristics = '';

    for (String line in lines) {
      if (line.trim().isNotEmpty &&
          (line.contains('Colour:') ||
              line.contains('Horn Shape') ||
              line.contains('Characteristics:'))) {
        characteristics += '${line.trim()} ';
        if (characteristics.length > 150) break;
      }
    }

    return characteristics.isNotEmpty
        ? characteristics
        : 'Hardy breed with distinctive features.';
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answerIndex;
    });
  }

  int _calculateCurrentScore() {
    int score = 0;
    for (int i = 0; i <= _currentQuestionIndex; i++) {
      if (_selectedAnswers[i] != null &&
          _selectedAnswers[i] == _questions[i]['correctAnswer']) {
        score++;
      }
    }
    return score;
  }

  int _calculateTotalScore() {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] != null &&
          _selectedAnswers[i] == _questions[i]['correctAnswer']) {
        score++;
      }
    }
    return score;
  }

  void _nextQuestion() {
    if (_selectedAnswers[_currentQuestionIndex] != null) {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
        });
      } else {
        setState(() {
          _score = _calculateTotalScore(); // Calculate final score
          _quizCompleted = true;
        });
      }
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _selectedMode = null;
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
      _questions.clear();
      _selectedAnswers = [];
    });
  }

  void _retakeSameQuiz() {
    setState(() {
      _generateQuestions();
      _selectedAnswers = List.filled(_questions.length, null);
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quizCompleted) {
      return _buildResultScreen();
    }

    if (_selectedMode == null) {
      return _buildModeSelectionScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_getModeTitle()),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restartQuiz,
            tooltip: 'Change Quiz Mode',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'Score: ${_calculateCurrentScore()}/${_currentQuestionIndex + 1}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.border,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / _questions.length,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryGreen,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Question Content with Navigation Buttons
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildQuestionContent(),
                    const SizedBox(height: 24),

                    // Navigation Buttons inside scroll area
                    Row(
                      children: [
                        if (_currentQuestionIndex > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _previousQuestion,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primaryGreen,
                                side: const BorderSide(
                                  color: AppColors.primaryGreen,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Previous'),
                            ),
                          ),
                        if (_currentQuestionIndex > 0)
                          const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                _selectedAnswers[_currentQuestionIndex] != null
                                ? _nextQuestion
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              _currentQuestionIndex == _questions.length - 1
                                  ? 'Finish Quiz'
                                  : 'Next Question',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), // Bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getModeTitle() {
    switch (_selectedMode!) {
      case QuizMode.imageBasedMCQ:
        return 'Image Quiz';
      case QuizMode.textBasedMCQ:
        return 'Description Quiz';
      case QuizMode.reverseQuiz:
        return 'Reverse Quiz';
    }
  }

  String _getThemeName(QuizTheme theme) {
    switch (theme) {
      case QuizTheme.cattleOnly:
        return 'Cattle Breeds Only';
      case QuizTheme.buffaloOnly:
        return 'Buffalo Breeds Only';
      case QuizTheme.milkProducers:
        return 'High Milk Producers';
      case QuizTheme.draftAnimals:
        return 'Draft Animals';
      case QuizTheme.mixedBreeds:
        return 'Mixed Breeds';
      case QuizTheme.regionalFocus:
        return 'Regional Breeds';
      case QuizTheme.allBreeds:
        return 'All Breeds';
    }
  }

  String _getDifficultyName(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 'Easy';
      case DifficultyLevel.medium:
        return 'Medium';
      case DifficultyLevel.hard:
        return 'Hard';
    }
  }

  Widget _buildModeSelectionScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Quiz Mode'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Select Your Quiz Mode',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Test your knowledge of cattle and buffalo breeds',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Image-based MCQ Mode
            _buildModeCard(
              title: 'Image Quiz',
              description: 'Identify breeds from images',
              icon: Icons.image,
              mode: QuizMode.imageBasedMCQ,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),

            // Text-based MCQ Mode
            _buildModeCard(
              title: 'Description Quiz',
              description: 'Match characteristics to breeds',
              icon: Icons.description,
              mode: QuizMode.textBasedMCQ,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),

            // Reverse Quiz Mode
            _buildModeCard(
              title: 'Reverse Quiz',
              description: 'Find the correct image for breed names',
              icon: Icons.swap_horiz,
              mode: QuizMode.reverseQuiz,
              color: Colors.purple,
            ),

            const SizedBox(height: 40),

            // Daily Challenge Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryGreen.withValues(alpha: 0.1),
                    AppColors.accentGreen.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryGreen.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.today,
                        color: AppColors.primaryGreen,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Today\'s Daily Challenge',
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Theme: ${_getThemeName(_getDailyTheme())}',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Difficulty: ${_getDifficultyName(_getDailyDifficulty())}',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primaryGreen),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Each quiz contains 5 questions. Daily challenges change every 24 hours!',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
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

  Widget _buildModeCard({
    required String title,
    required String description,
    required IconData icon,
    required QuizMode mode,
    required Color color,
  }) {
    return InkWell(
      onTap: () => _selectQuizMode(mode),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.textLight, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionContent() {
    final question = _questions[_currentQuestionIndex];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getQuestionIcon(),
                  color: AppColors.primaryGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Question ${_currentQuestionIndex + 1}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Question Content based on type
          if (question['type'] == 'image') ...[
            // Image Quiz
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  question['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.backgroundLight,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: AppColors.textLight,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
          ] else if (question['type'] == 'reverse') ...[
            // Reverse Quiz - Show breed name
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryGreen.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.pets, color: AppColors.primaryGreen),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      question['breedName'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Question Text
          Text(
            question['question'],
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          // Options
          Column(
            children: List.generate(question['options'].length, (index) {
              if (question['type'] == 'reverse') {
                return _buildImageOption(index, question);
              } else {
                return _buildTextOption(index, question);
              }
            }),
          ),
        ],
      ),
    );
  }

  IconData _getQuestionIcon() {
    switch (_selectedMode!) {
      case QuizMode.imageBasedMCQ:
        return Icons.image;
      case QuizMode.textBasedMCQ:
        return Icons.description;
      case QuizMode.reverseQuiz:
        return Icons.swap_horiz;
    }
  }

  Widget _buildTextOption(int index, Map<String, dynamic> question) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _selectAnswer(index),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: _selectedAnswers[_currentQuestionIndex] == index
                  ? AppColors.primaryGreen
                  : AppColors.border,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            color: _selectedAnswers[_currentQuestionIndex] == index
                ? AppColors.primaryGreen.withValues(alpha: 0.1)
                : Colors.white,
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedAnswers[_currentQuestionIndex] == index
                        ? AppColors.primaryGreen
                        : AppColors.textLight,
                    width: 2,
                  ),
                  color: _selectedAnswers[_currentQuestionIndex] == index
                      ? AppColors.primaryGreen
                      : Colors.white,
                ),
                child: _selectedAnswers[_currentQuestionIndex] == index
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question['options'][index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: _selectedAnswers[_currentQuestionIndex] == index
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageOption(int index, Map<String, dynamic> question) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _selectAnswer(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _selectedAnswers[_currentQuestionIndex] == index
                  ? AppColors.primaryGreen
                  : AppColors.border,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(12),
            color: _selectedAnswers[_currentQuestionIndex] == index
                ? AppColors.primaryGreen.withValues(alpha: 0.1)
                : Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Container with proper aspect ratio
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(11),
                    topRight: Radius.circular(11),
                  ),
                  color: AppColors.backgroundLight,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(11),
                    topRight: Radius.circular(11),
                  ),
                  child: Image.asset(
                    question['options'][index],
                    fit: BoxFit
                        .contain, // Changed from cover to contain for better visibility
                    width: double.infinity,
                    height: 160,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.backgroundLight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Image not found',
                              style: TextStyle(
                                color: AppColors.textLight,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Selection indicator and breed name
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              _selectedAnswers[_currentQuestionIndex] == index
                              ? AppColors.primaryGreen
                              : AppColors.textLight,
                          width: 2,
                        ),
                        color: _selectedAnswers[_currentQuestionIndex] == index
                            ? AppColors.primaryGreen
                            : Colors.white,
                      ),
                      child: _selectedAnswers[_currentQuestionIndex] == index
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        question['optionTitles'][index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              _selectedAnswers[_currentQuestionIndex] == index
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color:
                              _selectedAnswers[_currentQuestionIndex] == index
                              ? AppColors.primaryGreen
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    double percentage = (_score / _questions.length) * 100;
    String grade = percentage >= 80
        ? 'Excellent'
        : percentage >= 60
        ? 'Good'
        : percentage >= 40
        ? 'Average'
        : 'Needs Improvement';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Professional Score Circle
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: percentage >= 60
                      ? [
                          AppColors.success.withValues(alpha: 0.1),
                          AppColors.success.withValues(alpha: 0.2),
                        ]
                      : [
                          AppColors.warning.withValues(alpha: 0.1),
                          AppColors.warning.withValues(alpha: 0.2),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: percentage >= 60
                      ? AppColors.success
                      : AppColors.warning,
                  width: 6,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        (percentage >= 60
                                ? AppColors.success
                                : AppColors.warning)
                            .withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${percentage.toInt()}%',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: percentage >= 60
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_score/${_questions.length}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: percentage >= 60
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ),
                  Text(
                    'Correct',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color:
                    (percentage >= 60 ? AppColors.success : AppColors.warning)
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color:
                      (percentage >= 60 ? AppColors.success : AppColors.warning)
                          .withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                grade,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: percentage >= 60
                      ? AppColors.success
                      : AppColors.warning,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'You scored $_score out of ${_questions.length} questions correctly!',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Text(
              percentage >= 80
                  ? 'Outstanding knowledge of livestock breeds!'
                  : percentage >= 60
                  ? 'Good understanding, keep learning!'
                  : percentage >= 40
                  ? 'Fair attempt, more study needed.'
                  : 'Consider reviewing breed information.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _retakeSameQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 2,
                    ),
                    child: const Text('Retake Same Quiz'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _restartQuiz,
                    child: const Text('Try Different Mode'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
