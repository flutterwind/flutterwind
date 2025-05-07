import 'package:flutter/material.dart';
import 'package:flutterwind_core/src/utils/parser.dart';

class AnimationsClass {
  static const Map<String, Duration> durationScale = {
    'duration-75': Duration(milliseconds: 75),
    'duration-100': Duration(milliseconds: 100),
    'duration-200': Duration(milliseconds: 200),
    'duration-300': Duration(milliseconds: 300),
    'duration-500': Duration(milliseconds: 500),
  };

  static const Map<String, Curve> easingScale = {
    'ease-linear': Curves.linear,
    'ease-in': Curves.easeIn,
    'ease-out': Curves.easeOut,
    'ease-in-out': Curves.easeInOut,
  };

  static const Map<String, Curve> timingFunctions = {
    'linear': Curves.linear,
    'ease': Curves.ease,
    'ease-in': Curves.easeIn,
    'ease-out': Curves.easeOut,
    'ease-in-out': Curves.easeInOut,
    'bounce': Curves.bounceIn,
    'bounce-in': Curves.bounceIn,
    'bounce-out': Curves.bounceOut,
    'elastic': Curves.elasticIn,
    'elastic-in': Curves.elasticIn,
    'elastic-out': Curves.elasticOut,
    'back': Curves.easeInBack,
    'back-in': Curves.easeInBack,
    'back-out': Curves.easeOutBack,
  };

  static const Map<String, Duration> animationSpeedScale = {
    'animate-fast': Duration(milliseconds: 200),
    'animate-normal': Duration(milliseconds: 500),
    'animate-slow': Duration(milliseconds: 1000),
  };

  static void apply(String cls, FlutterWindStyle style) {
    if (cls.startsWith('animate-')) {
      final value = cls.substring(8);
      if (value.startsWith('duration-')) {
        _applyDuration(value.substring(9), style);
      } else if (value.startsWith('delay-')) {
        _applyDelay(value.substring(6), style);
      } else if (value.startsWith('timing-')) {
        _applyTimingFunction(value.substring(7), style);
      } else if (value.startsWith('iteration-')) {
        _applyIterationCount(value.substring(10), style);
      } else if (value.startsWith('direction-')) {
        _applyDirection(value.substring(10), style);
      } else if (value.startsWith('fill-')) {
        _applyFillMode(value.substring(5), style);
      } else if (value.startsWith('keyframes-')) {
        _applyKeyframes(value.substring(10), style);
      } else if (animationSpeedScale.containsKey(cls)) {
        style.transitionDuration = animationSpeedScale[cls]!;
      }
    }

    if (cls.startsWith('transition')) {
      style.transitionDuration = const Duration(milliseconds: 300);
    }

    if (cls.startsWith('duration-')) {
      final match = RegExp(r'duration-(\d+)').firstMatch(cls);
      if (match != null) {
        style.transitionDuration =
            Duration(milliseconds: int.parse(match.group(1)!));
      }
    }
    if (cls.startsWith('ease-')) {
      final match = RegExp(r'ease-(in|out|in-out|linear)').firstMatch(cls);
      if (match != null) {
        style.transitionCurve = easingScale[match.group(0)!];
      }
    }
  }

  static void _applyDuration(String value, FlutterWindStyle style) {
    final duration = int.tryParse(value);
    if (duration != null) {
      style.transitionDuration = Duration(milliseconds: duration);
    }
  }

  static void _applyDelay(String value, FlutterWindStyle style) {
    final delay = int.tryParse(value);
    if (delay != null) {
      style.transitionDelay = Duration(milliseconds: delay);
    }
  }

  static void _applyTimingFunction(String value, FlutterWindStyle style) {
    if (timingFunctions.containsKey(value)) {
      style.transitionCurve = timingFunctions[value];
    }
  }

  static void _applyIterationCount(String value, FlutterWindStyle style) {
    if (value == 'infinite') {
      style.animationIterationCount = -1;
    } else {
      final count = int.tryParse(value);
      if (count != null && count > 0) {
        style.animationIterationCount = count;
      }
    }
  }

  static void _applyDirection(String value, FlutterWindStyle style) {
    switch (value) {
      case 'normal':
        style.animationDirection = AnimationDirection.normal;
        break;
      case 'reverse':
        style.animationDirection = AnimationDirection.reverse;
        break;
      case 'alternate':
        style.animationDirection = AnimationDirection.alternate;
        break;
      case 'alternate-reverse':
        style.animationDirection = AnimationDirection.alternateReverse;
        break;
    }
  }

  static void _applyFillMode(String value, FlutterWindStyle style) {
    switch (value) {
      case 'none':
        style.animationFillMode = AnimationFillMode.none;
        break;
      case 'forwards':
        style.animationFillMode = AnimationFillMode.forwards;
        break;
      case 'backwards':
        style.animationFillMode = AnimationFillMode.backwards;
        break;
      case 'both':
        style.animationFillMode = AnimationFillMode.both;
        break;
    }
  }

  static void _applyKeyframes(String value, FlutterWindStyle style) {
    final keyframes = value.split(',');
    final animationKeyframes = <double, Map<String, dynamic>>{};

    for (final keyframe in keyframes) {
      final parts = keyframe.trim().split(':');
      if (parts.length == 2) {
        final percentage = double.tryParse(parts[0].replaceAll('%', ''));
        if (percentage != null && percentage >= 0 && percentage <= 100) {
          final properties = parts[1].trim().split(';');
          final keyframeProperties = <String, dynamic>{};

          for (final property in properties) {
            final propParts = property.trim().split(':');
            if (propParts.length == 2) {
              final propName = propParts[0].trim();
              final propValue = propParts[1].trim();
              keyframeProperties[propName] =
                  _parseKeyframeValue(propName, propValue);
            }
          }

          animationKeyframes[percentage / 100] = keyframeProperties;
        }
      }
    }

    if (animationKeyframes.isNotEmpty) {
      style.animationKeyframes = animationKeyframes;
    }
  }

  static dynamic _parseKeyframeValue(String property, String value) {
    switch (property) {
      case 'opacity':
        return double.tryParse(value);
      case 'scale':
        return double.tryParse(value);
      case 'rotate':
        return double.tryParse(value.replaceAll('deg', ''));
      case 'translateX':
      case 'translateY':
        return double.tryParse(value.replaceAll('px', ''));
      case 'backgroundColor':
        return _parseColor(value);
      default:
        return value;
    }
  }

  static Color? _parseColor(String value) {
    if (value.startsWith('#')) {
      return Color(int.parse(value.replaceAll('#', '0xFF')));
    }
    return null;
  }
}

enum AnimationDirection { normal, reverse, alternate, alternateReverse }

enum AnimationFillMode { none, forwards, backwards, both }
