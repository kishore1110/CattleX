import 'package:flutter/material.dart';
import '../main.dart';
import 'home_screen.dart';
import 'scanner_screen.dart';
import 'quiz_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const ScannerScreen(),
    const QuizScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: AppColors.primaryGreen,
              unselectedItemColor: AppColors.textLight,
              selectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _currentIndex == 0 
                        ? AppColors.primaryGreen.withValues(alpha: 0.1)
                        : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                      size: 24,
                    ),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _currentIndex == 1 
                        ? AppColors.primaryGreen.withValues(alpha: 0.1)
                        : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _currentIndex == 1 ? Icons.camera_alt : Icons.camera_alt_outlined,
                      size: 24,
                    ),
                  ),
                  label: 'Scanner',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _currentIndex == 2 
                        ? AppColors.primaryGreen.withValues(alpha: 0.1)
                        : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _currentIndex == 2 ? Icons.quiz : Icons.quiz_outlined,
                      size: 24,
                    ),
                  ),
                  label: 'Quiz',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
