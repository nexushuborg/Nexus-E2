import 'package:flutter/material.dart';
import '../theme.dart';
import '../utils/ui_constants.dart';

class AvatarCircle extends StatelessWidget {
  final double size;
  final bool isPlaceholder;
  final VoidCallback? onTap;
  final Widget? child;

  const AvatarCircle({
    Key? key,
    this.size = UIConstants.avatarSizeMedium,
    this.isPlaceholder = true,
    this.onTap,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(UIConstants.glassOpacity),
          shape: BoxShape.circle,
        ),
        child: child ?? (isPlaceholder ? Icon(
          Icons.person_outline,
          size: size * 0.5,
          color: AppTheme.primaryColor,
        ) : null),
      ),
    );
  }
}

class CameraButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;

  const CameraButton({
    Key? key,
    this.onTap,
    this.size = 36,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.camera_alt,
          color: Colors.white,
          size: size * 0.5,
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final VoidCallback? onTap;

  const GlassCard({
    Key? key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(UIConstants.spacingLarge),
        decoration: UIConstants.glassDecoration(
          radius: borderRadius ?? UIConstants.glassRadius,
        ),
        child: child,
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const NextButton({
    Key? key,
    required this.onPressed,
    this.label = 'Next',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: UIConstants.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIConstants.buttonRadius),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: UIConstants.spacingSmall),
            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
