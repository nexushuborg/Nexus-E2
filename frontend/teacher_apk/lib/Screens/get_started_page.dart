// ================== Imports ==================
import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/glass_frame.dart';

// ================== Card Data Model ==================
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

// ================== Get Started Page ==================
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
      description:
          "Your all-in-one platform for class updates and student management. Teach more, manage less!",
    ),
    CardData(
      title: "Your Digital",
      prominentTitle: "Briefcase!",
      description:
          "Easily upload and share notes, keeping all your teaching materials organized and accessible to students anytime, anywhere.",
    ),
    CardData(
      title: "Classroom",
      prominentTitle: "Commander!",
      description:
          "Access student details, share important notices instantly, and empower your class by appointing Class Representatives with just a few taps.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (mounted) {
        setState(() {
          _currentPage = _pageController.page?.round() ?? 0;
        });
      }
    });
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (!mounted) return;
      int pageForDecision = _pageController.page?.round() ?? 0;
      if (pageForDecision < _cardData.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 400),
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

  // ================== Page Indicator ==================
  Widget _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _cardData.length; i++) {
      indicators.add(
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _currentPage == i ? AppTheme.primaryColor : Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }

  // ================== Card Item Builder ==================
  Widget _buildCardItem(BuildContext context, int index) {
    final card = _cardData[index];
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 40, 32, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            card.title,
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            card.prominentTitle,
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            card.description,
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 18,
              height: 1.5,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  // ================== Build Method ==================
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final contentHeight = screenHeight * 0.35;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.backgroundGradientStart, AppTheme.backgroundGradientEnd],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GlassFrame(
                borderRadius: 32,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: contentHeight,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _cardData.length,
                          itemBuilder: (context, index) {
                            return _buildCardItem(context, index);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildPageIndicator(),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              _timer?.cancel();
                              Navigator.pushReplacementNamed(context, 'login');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Get Started',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
