// ================== Imports ==================
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/arcanum_logo.dart';
import '../widgets/common_widgets.dart';
import '../utils/ui_constants.dart';

// ================== Profile Page ==================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
        body: SafeArea(
          child: Column(
            children: [
              // ================== Top Bar ==================
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 24, 24),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppTheme.primaryColor),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: UIConstants.spacingMedium),
                    Text(
                      'Your Profile',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.settings, color: AppTheme.primaryColor),
                      onPressed: () => Navigator.pushNamed(context, 'settings'),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: UIConstants.spacingXLarge),

              // ================== Avatar and Name ==================
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 190.0 + 0.0 * 2,
                    height: 190.0 + 4.0 * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primaryColor.withAlpha(128),
                        width: 8.0,
                      ),
                    ),
                  ),
                  AvatarCircle(
                    size: 190.0,
                    onTap: () {},
                  ),
                  Positioned(
                    right: 15.0,
                    bottom: 15.0,
                    child: CameraButton(onTap: () {}),
                  ),
                ],
              ),
              const SizedBox(height: UIConstants.spacingLarge),
              Text(
                'Santosh Kumar',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: UIConstants.spacingSmall),
              Text(
                'Professor',
                style: TextStyle(
                  color: AppTheme.primaryColor.withAlpha(204),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: UIConstants.spacingXLarge),

              // ================== Profile Details Card ==================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: UIConstants.spacingLarge),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Profile Details',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: UIConstants.spacingXLarge),
                      _ProfileDetailRow(label: 'Mail', value: 'santkumar@gmail.com'),
                      const SizedBox(height: UIConstants.spacingSmall),
                      _ProfileDetailRow(label: 'Degree', value: 'M Tech'),
                      const SizedBox(height: UIConstants.spacingSmall),
                      _ProfileDetailRow(label: 'Department', value: 'CSE'),
                      const SizedBox(height: UIConstants.spacingMedium),
                      const Text(
                        'Sections:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: UIConstants.spacingSmall),
                      Wrap(
                        spacing: UIConstants.spacingSmall,
                        runSpacing: UIConstants.spacingSmall,
                        children: [
                          '24E1A2',
                          '24E1A2',
                          '22E1A1',
                          '21E1C3',
                        ].map((section) => _SectionChip(label: section)).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),
              // ================== Logo at Bottom ==================
              Padding(
                padding: const EdgeInsets.only(bottom: UIConstants.spacingLarge),
                child: ArcanumLogo(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== Profile Detail Row ==================
class _ProfileDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: UIConstants.spacingSmall),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: AppTheme.primaryColor.withAlpha(204),
            ),
          ),
        ),
      ],
    );
  }
}

// ================== Section Chip ==================
class _SectionChip extends StatelessWidget {
  final String label;

  const _SectionChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.spacingMedium,
        vertical: UIConstants.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UIConstants.buttonRadius),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
