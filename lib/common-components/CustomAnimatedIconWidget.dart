// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum AnimationType {
  Scale,
  Rotate,
  Translate,
  Opacity,
  Color,
  Bounce,
  Shake,
}

class CustomAnimatedIconWidget extends StatefulWidget {
  final Widget icon;
  final AnimationType animationType;
  final double? iconSize;
  final bool playAutomatically;

  const CustomAnimatedIconWidget({
    super.key,
    required this.icon,
    required this.animationType,
    required this.iconSize,
    this.playAutomatically = true,
  });

  @override
  _CustomAnimatedIconWidgetState createState() =>
      _CustomAnimatedIconWidgetState();
}

class _CustomAnimatedIconWidgetState extends State<CustomAnimatedIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<dynamic> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    switch (widget.animationType) {
      case AnimationType.Scale:
        _animation =
            Tween<double>(begin: 0.8, end: 1.2).animate(_animationController);
        break;
      case AnimationType.Rotate:
        _animation = Tween<double>(begin: 0, end: 2 * 3.14159)
            .animate(_animationController);
        break;
      case AnimationType.Translate:
        _animation =
            Tween<double>(begin: -50, end: 50).animate(_animationController);
        break;
      case AnimationType.Opacity:
        _animation =
            Tween<double>(begin: 0.2, end: 1.0).animate(_animationController);
        break;
      case AnimationType.Color:
        _animation = ColorTween(
          begin: Colors.red,
          end: Colors.blue,
        ).animate(_animationController);
        break;
      case AnimationType.Bounce:
        _animation =
            Tween<double>(begin: -50, end: 0).animate(_animationController);
        break;
      case AnimationType.Shake:
        _animation =
            Tween<double>(begin: -15, end: 15).animate(_animationController);
        break;
    }

    if (widget.playAutomatically) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (!widget.playAutomatically) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _startAnimation();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          switch (widget.animationType) {
            case AnimationType.Scale:
              return Transform.scale(
                scale: _animation.value,
                child: widget.icon,
              );
            case AnimationType.Rotate:
              return Transform.rotate(
                angle: _animation.value,
                child: widget.icon,
              );
            case AnimationType.Translate:
              return Transform.translate(
                offset: Offset(_animation.value, 0),
                child: widget.icon,
              );
            case AnimationType.Opacity:
              return Opacity(
                opacity: _animation.value,
                child: widget.icon,
              );
            case AnimationType.Color:
              return IconTheme(
                data: IconThemeData(
                    color: _animation.value, size: widget.iconSize),
                child: widget.icon,
              );
            case AnimationType.Bounce:
              return Transform.translate(
                offset: Offset(0, _animation.value.abs()),
                child: widget.icon,
              );
            case AnimationType.Shake:
              return Transform.rotate(
                angle: _animation.value * 0.01745, // Convert degrees to radians
                child: widget.icon,
              );
            default:
              return widget.icon;
          }
        },
      ),
    );
  }
}
