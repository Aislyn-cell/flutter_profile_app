import 'package:flutter/material.dart';

class FlyingHeartWidget extends StatefulWidget {
  const FlyingHeartWidget({required this.heart, super.key});

  final _FlyingHeart heart;

  @override
  State<FlyingHeartWidget> createState() => _FlyingHeartWidgetState();
}

class _FlyingHeartWidgetState extends State<FlyingHeartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.heart.animationDuration,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          // Animation completed
        });
      }
    });

    _positionAnimation = Tween<Offset>(
      begin: widget.heart.beginPosition,
      end:
          widget.heart.beginPosition +
          Offset(widget.heart.randomX, widget.heart.randomY),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: widget.heart.curve),
    );

    _scaleAnimation = Tween<double>(
      begin: widget.heart.size,
      end: widget.heart.size * 1.5,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: _positionAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Icon(
              Icons.favorite,
              color: Colors.pink[300],
              size: widget.heart.size,
            ),
          ),
        );
      },
    );
  }
}

class _FlyingHeart {
  _FlyingHeart({
    required this.beginPosition,
    required this.size,
    required this.animationDuration,
    required this.curve,
    required this.randomX,
    required this.randomY,
  });

  final Offset beginPosition;
  final double size;
  final Duration animationDuration;
  final Curve curve;
  final double randomX;
  final double randomY;
}
