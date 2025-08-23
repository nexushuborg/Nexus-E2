import 'package:flutter/material.dart';
import '../theme.dart';
import '../routes.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedDeadlineType = 'Assignment';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.mainGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Top Bar with ARCANUM logo and icons
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: AppTheme.buttonBg,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pushNamed(context, Routes.settings),
                            icon: const Icon(
                              Icons.settings,
                              color: AppTheme.buttonBg,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Profile Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, Routes.profile),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppTheme.buttonBg,
                          radius: 24,
                          child: Text(
                            'S',
                            style: TextStyle(
                              color: AppTheme.textColor2,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hey Student!',
                              style: TextStyle(
                                color: AppTheme.textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Welcome Back!',
                              style: TextStyle(
                                color: AppTheme.textColor.withAlpha(178),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Quick Access Cards
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQuickAccessCard('Materials', Icons.book_outlined),
                      _buildQuickAccessCard('Library', Icons.library_books_outlined),
                      _buildQuickAccessCard('Doubt', Icons.help_outline),
                    ],
                  ),
                ),
              ),

              // Deadlines Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Submission Deadlines',
                        style: TextStyle(
                          color: AppTheme.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            color: AppTheme.textColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Deadline Type Filter
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Row(
                    children: [
                      _buildFilterChip('Assignment'),
                      const SizedBox(width: 12),
                      _buildFilterChip('Project'),
                      const SizedBox(width: 12),
                      _buildFilterChip('Lab'),
                    ],
                  ),
                ),
              ),

              // Deadline Cards
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      _buildDeadlineCard(
                        date: 'Aug\n25',
                        title: 'COA Assignment 5',
                        description: 'To be submitted in the assignment copy.',
                        priority: 'High',
                      ),
                      const SizedBox(height: 12),
                      _buildDeadlineCard(
                        date: 'Sept\n12',
                        title: 'IM Assignment 2',
                        description: 'To be submitted in the A4 copy.',
                        priority: 'Mid',
                      ),
                      const SizedBox(height: 12),
                      _buildDeadlineCard(
                        date: 'Sept\n25',
                        title: 'ALA Assignment 3',
                        description: 'To be submitted in the assignment copy.',
                        priority: 'Low',
                      ),
                    ],
                  ),
                ),
              ),

              // Notice Board
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notice Board',
                        style: TextStyle(
                          color: AppTheme.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Search Bar
                      Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(25),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: AppTheme.textColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(color: AppTheme.textColor),
                                decoration: InputDecoration(
                                  hintText: 'Search for notice, exams and many more',
                                  hintStyle: TextStyle(color: AppTheme.textColor.withAlpha(128)),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const Icon(Icons.tune, color: AppTheme.textColor),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Notice Items
                      _buildNoticeItem(
                        icon: Icons.school_outlined,
                        tag: 'College',
                        title: 'Notice regarding Elysium',
                        subtitle: 'Our intra-college fest, Elysium will take place during the first week of April.',
                        time: '2hr ago',
                      ),
                      const SizedBox(height: 16),
                      _buildNoticeItem(
                        icon: Icons.people_outline,
                        tag: 'Communities',
                        title: 'Semester Exams Schedule Released',
                        subtitle: 'The final exam timetable for the odd semester is now available. Exams start from December 2nd.',
                        time: '2hr ago',
                      ),
                      const SizedBox(height: 16),
                      _buildNoticeItem(
                        icon: Icons.class_outlined,
                        tag: 'Class',
                        title: 'AAD Quiz 2',
                        subtitle: 'AAD quiz 2 to take place on Friday, 13th October. Bring A4 sheets.',
                        time: '2hr ago',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessCard(String title, IconData icon) {
    return InkWell(
      onTap: () {
        if (title == 'Materials') {
          Navigator.pushNamed(context, Routes.materials);
        }
      },
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(220),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppTheme.backgroundGradientEnd.withAlpha(40),
              offset: const Offset(-2, 10),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 12,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.textColor2.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_outward,
                  color: AppTheme.textColor2,
                  size: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.textColor2.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: AppTheme.textColor2,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textColor2,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedDeadlineType == label;
    return InkWell(
      onTap: () => setState(() => _selectedDeadlineType = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.buttonBg : Colors.white.withAlpha(25),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          children: [
            Icon(
              label == 'Assignment' ? Icons.assignment_outlined :
              label == 'Project' ? Icons.task_outlined : Icons.science_outlined,
              color: isSelected ? AppTheme.textColor2 : AppTheme.textColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.textColor2 : AppTheme.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeadlineCard({
    required String date,
    required String title,
    required String description,
    required String priority,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),  // Changed from withOpacity
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Date
          Container(
            width: 48,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.buttonBg.withAlpha(51),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              date,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textColor2,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppTheme.textColor2,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: priority == 'High' ? Colors.red.withAlpha(25) :
                               priority == 'Mid' ? Colors.orange.withAlpha(25) :
                               Colors.green.withAlpha(25),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '$priority Priority',
                        style: TextStyle(
                          color: priority == 'High' ? Colors.red :
                                 priority == 'Mid' ? Colors.orange :
                                 Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: AppTheme.textColor2.withAlpha(179),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.arrow_forward, color: AppTheme.textColor2),
        ],
      ),
    );
  }

  Widget _buildNoticeItem({
    required IconData icon,
    required String tag,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),  // Changed from withOpacity
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.buttonBg.withAlpha(51),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.buttonBg),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.buttonBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: AppTheme.textColor2,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      time,
                      style: TextStyle(
                        color: AppTheme.textColor.withAlpha(179),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppTheme.textColor.withAlpha(179),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.arrow_forward, color: AppTheme.textColor),
        ],
      ),
    );
  }
}
