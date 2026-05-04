import 'package:compasscare_flutter/features/shell/presentation/pages/app_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, this.onCompleted, this.nextPageBuilder});

  final Future<void> Function()? onCompleted;
  final WidgetBuilder? nextPageBuilder;

  Future<void> _completeOnboarding(BuildContext context) async {
    if (onCompleted != null) {
      await onCompleted!.call();
    }
    if (!context.mounted) return;
    _openAppShell(context);
  }

  void _openAppShell(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (context) =>
            nextPageBuilder?.call(context) ?? const AppShellPage(),
      ),
      (route) => false,
    );
  }

  PageDecoration _pageDecoration(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return PageDecoration(
      titleTextStyle:
          textTheme.headlineSmall ??
          const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      bodyTextStyle:
          textTheme.bodyLarge ??
          const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
      contentMargin: const EdgeInsets.symmetric(horizontal: 20),
      imagePadding: const EdgeInsets.only(top: 36, bottom: 24),
      bodyPadding: const EdgeInsets.only(top: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return IntroductionScreen(
      globalBackgroundColor: colorScheme.surface,
      pages: [
        PageViewModel(
          title: 'Welcome to CompassCare',
          body: 'Track medications, reminders, and care details in one place.',
          image: Center(
            child: Image.asset('assets/images/logo.png', width: 180),
          ),
          decoration: _pageDecoration(context),
        ),
        PageViewModel(
          title: 'Medication Management',
          body:
              'View schedules, mark doses complete, and stay on top of treatment.',
          image: const Center(child: Icon(Icons.medication_rounded, size: 140)),
          decoration: _pageDecoration(context),
        ),
        PageViewModel(
          title: 'Appointments and Care Team',
          body:
              'Keep appointments organized and coordinate with your family and providers.',
          image: const Center(child: Icon(Icons.groups_rounded, size: 140)),
          decoration: _pageDecoration(context),
        ),
      ],
      showSkipButton: true,
      showBackButton: false,
      skip: Text(
        'Skip',
        style: textTheme.labelLarge?.copyWith(color: colorScheme.primary),
      ),
      next: Icon(Icons.arrow_forward_rounded, color: colorScheme.primary),
      done: Text(
        'Get Started',
        style: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.primary,
        ),
      ),
      onSkip: () async => _completeOnboarding(context),
      onDone: () async => _completeOnboarding(context),
      dotsDecorator: DotsDecorator(
        size: const Size(10, 10),
        activeSize: const Size(24, 10),
        color: colorScheme.primary.withAlpha(80),
        activeColor: colorScheme.primary,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      controlsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
