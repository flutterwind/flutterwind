import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

class AnimationPresets {
  static void apply(String cls, FlutterWindStyle style) {
    if (cls == 'animate-pulse') {
      style.animationPreset = AnimationPreset.pulse;
      style.transitionDuration = const Duration(milliseconds: 2000);
      style.transitionCurve = Curves.easeInOut;
    } else if (cls == 'animate-bounce') {
      style.animationPreset = AnimationPreset.bounce;
      style.transitionDuration = const Duration(milliseconds: 1000);
      style.transitionCurve = Curves.elasticOut;
    } else if (cls == 'animate-spin') {
      style.animationPreset = AnimationPreset.spin;
      style.transitionDuration = const Duration(milliseconds: 1000);
      style.transitionCurve = Curves.linear;
    } else if (cls == 'animate-ping') {
      style.animationPreset = AnimationPreset.ping;
      style.transitionDuration = const Duration(milliseconds: 1000);
      style.transitionCurve = Curves.easeInOut;
    } else if (cls == 'animate-fade') {
      style.animationPreset = AnimationPreset.fade;
      style.transitionDuration = const Duration(milliseconds: 500);
      style.transitionCurve = Curves.easeInOut;
    }
  }
  
  static Widget applyAnimationWidget(Widget child, AnimationPreset preset, Duration duration, Curve curve) {
    switch (preset) {
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
      case AnimationPreset.fade:
        return _FadeAnimation(
          child: child,
          duration: duration,
          curve: curve,
        );
      default:
        return child;
    }
  }
}

enum AnimationPreset {
  pulse,
  bounce,
  spin,
  ping,
  fade,
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

class _PulseAnimationState extends State<_PulseAnimation> with SingleTickerProviderStateMixin {
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
        tween: Tween<double>(begin: 1.0, end: 1.05)
            .chain(CurveTween(curve: widget.curve)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1.0)
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

class _BounceAnimationState extends State<_BounceAnimation> with SingleTickerProviderStateMixin {
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
        tween: Tween<double>(begin: 0, end: -10)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -10, end: 0)
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

class _SpinAnimationState extends State<_SpinAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
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
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
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

class _PingAnimationState extends State<_PingAnimation> with SingleTickerProviderStateMixin {
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
        tween: Tween<double>(begin: 1.0, end: 1.5)
            .chain(CurveTween(curve: widget.curve)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.5, end: 1.0)
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

class _FadeAnimationState extends State<_FadeAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0.5, end: 1.0)
        .chain(CurveTween(curve: widget.curve))
        .animate(_controller);
    
    _controller.repeat(reverse: true);
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