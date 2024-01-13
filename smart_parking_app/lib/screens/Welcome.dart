
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:smart_parking/screens//Login.dart';
import 'package:smart_parking/models/WelcomeSlide.dart';
import 'package:smart_parking/models/WelcomeSlideWidget.dart';
import 'package:smart_parking/themes/ColourThemes.dart';
import 'Dashboard.dart';

class WelcomeScreen extends StatelessWidget {
  final List<WelcomeSlide> slides = [
    WelcomeSlide(
      title: 'Find Parking Spaces',
      description: 'Locate available parking spaces nearby using our app.',
      imagePath: 'images/parkingmadeeasy.jpg', // Replace with your image path
    ),
    WelcomeSlide(
      title: 'Reserve Your Spot',
      description: 'Reserve parking spots in advance to save time and effort.',
      imagePath: 'images/3658184.jpg', // Replace with your image path
    ),
    WelcomeSlide(
      title: 'Track Your History',
      description: 'Keep track of your parking history and payments with ease.',
      imagePath: 'images/8450.jpg', // Replace with your image path
    ),
    WelcomeSlide(
      title: 'User-Friendly Experience',
      description:
          'Enjoy a user-friendly interface for a seamless parking experience.',
      imagePath: 'images/8960722.jpg', // Replace with your image path
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c4,
      appBar: AppBar(
        title: Text(
          "Welcome to UMT Parking App !",
          style: TextStyle(
              color: c1,
              fontSize: 25,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: c5,
        centerTitle: true,
      ),
      body: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return WelcomeSlideWidget(
            title: slides[index].title,
            description: slides[index].description,
            imagePath: slides[index].imagePath,
            isLastSlide: index == slides.length - 1,
            onPressed: () {
              if (index == slides.length - 1) {
                // If the last slide is tapped, navigate to RegisterScreen
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }
            },
          );
        },
        itemCount: slides.length,
        pagination: const SwiperPagination(),
        control: const SwiperControl(),
        loop: false,
      ),
    );
  }
}



