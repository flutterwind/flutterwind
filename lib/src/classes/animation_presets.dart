import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

class AnimationPresets {
  static void apply(String cls, FlutterWindStyle style) {
    if (cls.startsWith('animate-') || cls.startsWith('transition-')) {
      final value = cls.startsWith('animate-')
          ? cls.substring(8)
          : cls.substring('transition-'.length);

      // Handle duration modifiers
      if (value == 'slow') {
        style.transitionDuration = const Duration(milliseconds: 1000);
        return;
      } else if (value == 'normal') {
        style.transitionDuration = const Duration(milliseconds: 500);
        return;
      } else if (value == 'fast') {
        style.transitionDuration = const Duration(milliseconds: 200);
        return;
      }

      // Handle animation types
      style.animationPreset = _parseAnimationPreset(value);

      // Set default duration and curve if not already set
      if (style.transitionDuration == null) {
        style.transitionDuration = const Duration(milliseconds: 500);
      }
      if (style.transitionCurve == null) {
        style.transitionCurve = Curves.easeInOut;
      }
    }
  }

  static AnimationPreset _parseAnimationPreset(String value) {
    // Split the value to handle duration modifiers
    final parts = value.split(' ');
    final animationType = parts[0];

    switch (animationType) {
      case 'fade':
        return AnimationPreset.fade;
      case 'scale':
        return AnimationPreset.scale;
      case 'slide':
        return AnimationPreset.slide;
      case 'rotate':
        return AnimationPreset.rotate;
      case 'pulse':
        return AnimationPreset.pulse;
      case 'bounce':
        return AnimationPreset.bounce;
      case 'spin':
        return AnimationPreset.spin;
      case 'ping':
        return AnimationPreset.ping;
      case 'combined':
        return AnimationPreset.combined;
      default:
        return AnimationPreset.fade;
    }
  }

  static Widget applyAnimationWidget(
      Widget child, AnimationPreset preset, Duration duration, Curve curve) {
    if (preset == null) return child;
    return _applySingleAnimation(child, preset, duration, curve);
  }

  static Widget _applySingleAnimation(
      Widget child, AnimationPreset preset, Duration duration, Curve curve) {
    switch (preset) {
      case AnimationPreset.fade:
        return _FadeAnimation(
          child: child,
          duration: duration,
          curve: curve,
        );
      case AnimationPreset.scale:
        return _ScaleAnimation(
          child: child,
          duration: duration,
          curve: curve,
        );
      case AnimationPreset.slide:
        return _SlideAnimation(
          child: child,
          duration: duration,
          curve: curve,
        );
      case AnimationPreset.rotate:
        return _RotateAnimation(
          child: child,
          duration: duration,
          curve: curve,
        );
      case AnimationPreset.pulse:
        return _PulseAnimation(
          child: child,
          duration: duration,
          curve: curve,
        );
      case AnimationPreset.bounce:
        return _BounceAnimation(
          child: child,
          duration: duration,
          curve: curve,
        );
      case AnimationPreset.spin:
        return _SpinAnimation(
          child: child,
          duration: duration,
          curve: curve,
        );
      case AnimationPreset.ping:
        return _PingAnimation(
          child: child,
          duration: duration,
          curve: curve,
        );
      case AnimationPreset.combined:
        return _CombinedAnimation(
          child: child,
          duration: duration,
          curve: curve,
        );
    }
  }
}

enum AnimationPreset {
  pulse,
  bounce,
  spin,
  ping,
  fade,
  scale,
  slide,
  rotate,
  combined,
}

class _FadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const _FadeAnimation({
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  State<_FadeAnimation> createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<_FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: widget.curve))
        .animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

class _ScaleAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const _ScaleAnimation({
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  State<_ScaleAnimation> createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<_ScaleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: widget.curve))
        .animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

class _SlideAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const _SlideAnimation({
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  State<_SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<_SlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: widget.curve)).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

class _RotateAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const _RotateAnimation({
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  State<_RotateAnimation> createState() => _RotateAnimationState();
}

class _RotateAnimationState extends State<_RotateAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 2 * 3.14159)
        .chain(CurveTween(curve: widget.curve))
        .animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

class _PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const _PulseAnimation({
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: widget.curve)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: widget.curve)),
        weight: 50,
      ),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

class _BounceAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const _BounceAnimation({
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  State<_BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<_BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -20.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -20.0, end: 0.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: widget.child,
        );
      },
    );
  }
}

class _SpinAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const _SpinAnimation({
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  State<_SpinAnimation> createState() => _SpinAnimationState();
}

class _SpinAnimationState extends State<_SpinAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 2 * 3.14159)
        .chain(CurveTween(curve: widget.curve))
        .animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

class _PingAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const _PingAnimation({
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  State<_PingAnimation> createState() => _PingAnimationState();
}

class _PingAnimationState extends State<_PingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 2.0)
            .chain(CurveTween(curve: widget.curve)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 2.0, end: 1.0)
            .chain(CurveTween(curve: widget.curve)),
        weight: 50,
      ),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Opacity(
            opacity: 2 - _animation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _CombinedAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const _CombinedAnimation({
    required this.child,
    required this.duration,
    required this.curve,
  });

  @override
  State<_CombinedAnimation> createState() => _CombinedAnimationState();
}

class _CombinedAnimationState extends State<_CombinedAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).chain(CurveTween(curve: widget.curve)).animate(_controller);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).chain(CurveTween(curve: widget.curve)).animate(_controller);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0),
      end: Offset.zero,
    ).chain(CurveTween(curve: widget.curve)).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _slideAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
