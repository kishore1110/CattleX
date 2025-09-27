import 'package:flutter/material.dart';
import '../main.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  List<int?> _selectedAnswers = [];

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Which breed is known as the "Pride of Gujarat"?',
      'options': ['Gir', 'Sahiwal', 'Red Sindhi', 'Tharparkar'],
      'correctAnswer': 0,
      'explanation': 'Gir cattle, originating from Gujarat, are known for their distinctive appearance and high milk yield.',
    },
    {
      'question': 'What is the average milk yield of Murrah buffalo per day?',
      'options': ['5-8 liters', '10-15 liters', '15-20 liters', '20-25 liters'],
      'correctAnswer': 2,
      'explanation': 'Murrah buffalo typically produces 15-20 liters of milk per day with high fat content.',
    },
    {
      'question': 'Which characteristic is unique to Holstein Friesian cattle?',
      'options': ['Black and white patches', 'Humped back', 'Small size', 'Brown color'],
      'correctAnswer': 0,
      'explanation': 'Holstein Friesian cattle are easily recognizable by their distinctive black and white patches.',
    },
    {
      'question': 'What is the primary purpose of Khillari cattle?',
      'options': ['Milk production', 'Draft work', 'Meat production', 'Both A and B'],
      'correctAnswer': 1,
      'explanation': 'Khillari cattle are primarily used for draft work and are known for their strength and endurance.',
    },
    {
      'question': 'Which buffalo breed is native to Punjab?',
      'options': ['Murrah', 'Nili-Ravi', 'Surti', 'Jaffarabadi'],
      'correctAnswer': 1,
      'explanation': 'Nili-Ravi buffalo is native to Punjab and is known for its high milk production.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List.filled(_questions.length, null);
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (_selectedAnswers[_currentQuestionIndex] != null) {
      if (_selectedAnswers[_currentQuestionIndex] == _questions[_currentQuestionIndex]['correctAnswer']) {
        _score++;
      }
      
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
        });
      } else {
        setState(() {
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
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
      _selectedAnswers = List.filled(_questions.length, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quizCompleted) {
      return _buildResultScreen();
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breed Knowledge Quiz'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    'Score: $_score/$_currentQuestionIndex',
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
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Professional Question Card
            Container(
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.quiz,
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
                  Text(
                    _questions[_currentQuestionIndex]['question'],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                    
                    // Answer Options
                    ...List.generate(
                      _questions[_currentQuestionIndex]['options'].length,
                      (index) => Padding(
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
                                    _questions[_currentQuestionIndex]['options'][index],
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
                      ),
                    ),
                  ],
                ),
              ),
            
            const Spacer(),
            
            // Navigation Buttons
            Row(
              children: [
                if (_currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousQuestion,
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentQuestionIndex > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedAnswers[_currentQuestionIndex] != null
                        ? _nextQuestion
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 2,
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
          ],
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    double percentage = (_score / _questions.length) * 100;
    String grade = percentage >= 80 ? 'Excellent' : 
                   percentage >= 60 ? 'Good' : 
                   percentage >= 40 ? 'Average' : 'Needs Improvement';
    
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
                    ? [AppColors.success.withValues(alpha: 0.1), AppColors.success.withValues(alpha: 0.2)]
                    : [AppColors.warning.withValues(alpha: 0.1), AppColors.warning.withValues(alpha: 0.2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: percentage >= 60 ? AppColors.success : AppColors.warning,
                  width: 6,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (percentage >= 60 ? AppColors.success : AppColors.warning).withValues(alpha: 0.3),
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
                      color: percentage >= 60 ? AppColors.success : AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_score/${_questions.length}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: percentage >= 60 ? AppColors.success : AppColors.warning,
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
                color: (percentage >= 60 ? AppColors.success : AppColors.warning).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: (percentage >= 60 ? AppColors.success : AppColors.warning).withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                grade,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: percentage >= 60 ? AppColors.success : AppColors.warning,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              'You scored $_score out of ${_questions.length} questions correctly!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              percentage >= 80 ? 'Outstanding knowledge of livestock breeds!' :
              percentage >= 60 ? 'Good understanding, keep learning!' :
              percentage >= 40 ? 'Fair attempt, more study needed.' :
              'Consider reviewing breed information.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _restartQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 2,
                    ),
                    child: const Text('Retake Quiz'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to breed database or learning materials
                    },
                    child: const Text('Learn More About Breeds'),
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
