import 'package:flutter/material.dart';
import 'package:smart_parking/themes/ColourThemes.dart';

class WelcomeSlideWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final bool isLastSlide;
  final VoidCallback onPressed;

  WelcomeSlideWidget({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.isLastSlide,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 50,
        ),
        Card(
          elevation: 5,
          margin: EdgeInsets.all(35),
          color: c4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26.0),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.asset(
                  imagePath,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  description,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 25,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        if (isLastSlide)
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text(
              'Get Started',
              style: TextStyle(color: Colors.black),
            ),
          ),
      ],
    );
  }
}
