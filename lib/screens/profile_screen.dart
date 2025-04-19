import 'package:flutter/material.dart';
import 'dart:math';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  bool _isLiked = false;
  late AnimationController _likeController;
  late Animation<double> _likeAnimation;
  final List<_FlyingHeart> _flyingHearts = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _likeAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _likeController, curve: Curves.easeInOut),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _likeController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _likeController.forward(from: 0.0);
        _spawnFlyingHearts();
      }
    });
  }

  void _spawnFlyingHearts() {
    // Removed unused variable 'overlay'
    final double heartSize = 24.0;

    for (int i = 0; i < 10; i++) {
      _flyingHearts.add(
        _FlyingHeart(
          beginPosition: Offset(
            MediaQuery.of(context).size.width / 2 +
                _random.nextDouble() * 40 -
                20,
            MediaQuery.of(context).size.height * 0.6 +
                _random.nextDouble() * 40 -
                20,
          ),
          size:
              heartSize *
              (_random.nextDouble() * 0.5 + 0.75), // Slightly varying size
          animationDuration: Duration(
            milliseconds: 1500 + _random.nextInt(1000),
          ),
          curve: Curves.easeInOut,
          randomX:
              _random.nextDouble() * 200 - 100, // Random horizontal movement
          randomY: -_random.nextDouble() * 200 - 50, // Move upwards
        ),
      );
    }

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _flyingHearts.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.pink[100],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150/FFC0CB/FFFFFF?Text=Lovely%20User',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Lovely User',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Flutter Developer in Cheonan',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _toggleLike,
                  child: ScaleTransition(
                    scale: _likeAnimation,
                    child: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.pink,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${_isLiked ? 'Liked!' : 'Like'}',
                  style: const TextStyle(color: Colors.pink),
                ),
              ],
            ),
          ),
          ..._flyingHearts
              .map((heart) => FlyingHeartWidget(heart: heart))
              .toList(),
        ],
      ),
    );
  }
}

class FlyingHeartWidget extends StatelessWidget {
  final _FlyingHeart heart;

  const FlyingHeartWidget({Key? key, required this.heart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: heart.beginPosition.dx,
      top: heart.beginPosition.dy,
      child: Icon(Icons.favorite, color: Colors.pink, size: heart.size),
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
