// Get Started screen shown after loading
import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../routes.dart';
import '../widgets/glass_frame.dart';

class CardData {
  final String title;
  final String prominentTitle;
  final String description;

  CardData({
    required this.title,
    required this.prominentTitle,
    required this.description,
  });
}

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<CardData> _cardData = [
    CardData(
      title: "Welcome to",
      prominentTitle: "Arcanum!",
      description: "All your class updates and academia management tools in one place—quick, organized, and effortless, so you learn more and manage less",
    ),
    CardData(
      title: "Your Digital",
      prominentTitle: "Briefcase!",
      description: "Keep all your academic materials organized and accessible anytime, anywhere",
    ),
    CardData(
      title: "Classroom",
      prominentTitle: "Commander!",
      description: "Stay on top of assignments, tests, and important updates with real-time notifications",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _cardData.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.mainGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Background illustration
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/get_started_illustration.png',  // Fixed image name
                height: MediaQuery.of(context).size.height * 0.5,  // Reduced height
                fit: BoxFit.cover,
              ),
            ),
            // Main content
            Column(
              children: [
                const SizedBox(height: 48),
                const Text(
                  'Arcanum',
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 24,
                    fontFamily: 'MajorMonoDisplay',
                    fontWeight: FontWeight.w300,
                    letterSpacing: 4,
                  ),
                ),
                const Spacer(),
                // Bottom glass frame with content
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,  // Reduced glass frame height
                  width: double.infinity,
                  child: GlassFrame(
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() => _currentPage = index);
                            },
                            itemCount: _cardData.length,
                            itemBuilder: (context, index) {
                              final card = _cardData[index];
                              return Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      card.title,
                                      style: const TextStyle(
                                        color: AppTheme.textColor,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      card.prominentTitle,
                                      style: const TextStyle(
                                        color: AppTheme.textColor,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      card.description,
                                      style: TextStyle(
                                        color: AppTheme.textColor.withAlpha(178),
                                        fontSize: 18,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 48),
                          child: Column(
                            children: [
                              // Page indicators
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(_cardData.length, (index) {
                                  return Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentPage == index
                                          ? AppTheme.buttonBg
                                          : AppTheme.textColor.withAlpha(76),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 32),
                              // Get Started button
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _timer?.cancel();
                                      Navigator.pushReplacementNamed(context, Routes.login);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.buttonBg,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Get Started',
                                          style: TextStyle(
                                            color: AppTheme.textColor2,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons.arrow_forward, color: AppTheme.textColor2),
                                      ],
                                    ),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MajorMonoDisplay {
  static const String fontFamily = 'MajorMonoDisplay';
  static const String fontPath = 'assets/fonts/MajorMonoDisplay-Regular.ttf';
}
