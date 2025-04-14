import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
    _navigateToHome();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF4A148C), // Deep purple 900 (primary color)
                  Color.lerp(
                    const Color(0xFF4A148C), // Primary color
                    const Color(0xFF7C4DFF), // Secondary color
                    _backgroundAnimation.value,
                  )!,
                ],
                stops: const [0.3, 1.0],
              ),
            ),
            child: child,
          );
        },
        child: Stack(
          children: [
            // Advanced background patterns
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Opacity(
                    opacity: _fadeAnimation.value * 0.3,
                    child: CustomPaint(
                      painter: BackgroundPatternPainter(
                        progress: _controller.value,
                        primaryColor: const Color(0xFF4A148C), // Primary color
                        secondaryColor:
                            const Color(0xFF7C4DFF), // Secondary color
                      ),
                    ),
                  );
                },
              ),
            ),

            // Radial gradient overlay
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _backgroundAnimation,
                builder: (context, _) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.0, -0.3),
                        radius: 0.8,
                        colors: [
                          const Color(0xFF9575CD)
                              .withOpacity(0.3 * _backgroundAnimation.value),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  );
                },
              ),
            ),

            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // App icon with animations
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer rotating circle with glowing effect
                        AnimatedBuilder(
                          animation: _rotateAnimation,
                          builder: (context, child) {
                            return Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: SweepGradient(
                                  colors: [
                                    const Color(0xFF7C4DFF),
                                    const Color(0xFF3949AB),
                                    const Color(0xFF512DA8).withOpacity(0.8),
                                    const Color(0xFF7C4DFF),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF7C4DFF)
                                        .withOpacity(0.5),
                                    blurRadius: 15,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Transform.rotate(
                                angle: _rotateAnimation.value,
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Middle ring
                        AnimatedBuilder(
                          animation: _rotateAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: -_rotateAnimation.value * 0.5,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF9575CD),
                                      Color(0xFF512DA8)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // App icon
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.auto_stories,
                                size: 60,
                                color: Color(0xFF5E35B1), // Match primary color
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // App tagline
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Text(
                          'Stories & Games',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Loading indicator
                    FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _controller,
                        curve: const Interval(0.4, 1.0),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 3,
                              backgroundColor: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading your adventures...',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom background pattern painter
class BackgroundPatternPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  BackgroundPatternPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw geometric patterns - concentric circles
    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const int circleCount = 8;
    for (int i = 0; i < circleCount; i++) {
      final radius = size.width * 0.8 * (i / circleCount) * progress;
      canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.4),
        radius,
        circlePaint,
      );
    }

    // Create floating dots
    final dotPaint = Paint()..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent pattern
    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final rad = 1.5 + random.nextDouble() * 3.0 * progress;

      // Vary the dot colors
      if (i % 3 == 0) {
        dotPaint.color = secondaryColor.withOpacity(0.3);
      } else if (i % 3 == 1) {
        dotPaint.color = primaryColor.withOpacity(0.3);
      } else {
        dotPaint.color = Colors.white.withOpacity(0.2);
      }

      canvas.drawCircle(
        Offset(x, y),
        rad,
        dotPaint,
      );
    }

    // Draw some crossed lines
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int i = 0; i < 5; i++) {
      final y = size.height * (i / 5.0);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    for (int i = 0; i < 5; i++) {
      final x = size.width * (i / 5.0);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
  }

  @override
  bool shouldRepaint(BackgroundPatternPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
