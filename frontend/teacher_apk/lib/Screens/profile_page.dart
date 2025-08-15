// Teacher's Profile screen
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/arcanum_logo.dart';
import '../widgets/common_widgets.dart';
import '../utils/ui_constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
              // Top Bar
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

              // Avatar and Name
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AvatarCircle(
                    size: UIConstants.avatarSizeLarge,
                    onTap: () {},
                  ),
                  Positioned(
                    right: -4,
                    bottom: -4,
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
              const SizedBox(height: UIConstants.spacingXLarge),

              // Profile Details Card
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
                          const Spacer(),
                          GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.edit,
                              color: AppTheme.primaryColor,
                              size: UIConstants.iconSizeMedium,
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
              // Logo at bottom
              Padding(
                padding: const EdgeInsets.only(bottom: UIConstants.spacingLarge),
                child: ArcanumLogo(color: AppTheme.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
              color: AppTheme.primaryColor.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
}

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
