import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';

class CarouselSliderComponent extends StatefulWidget {
  const CarouselSliderComponent({super.key});

  @override
  State<CarouselSliderComponent> createState() =>
      _CarouselSliderComponentState();
}

class _CarouselSliderComponentState extends State<CarouselSliderComponent> {
  final List<String> allProducts = [
    "https://picsum.photos/600/400?random=1",
    "https://picsum.photos/600/400?random=2",
    "https://picsum.photos/600/400?random=3",
    "https://picsum.photos/600/400?random=4",
    "https://picsum.photos/600/400?random=5",
    "https://picsum.photos/600/400?random=6",
  ];

  int initialCarouselIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Carousel"),
        elevation: 5,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              scrollDirection: Axis.horizontal,
              height: 300,
              viewportFraction: 0.8,
              enlargeCenterPage: true,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  initialCarouselIndex = index;
                });
                print("Current Index: $initialCarouselIndex");
              },
            ),
            items: allProducts.map((imageUrl) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      "assets/images/placeholder.jpg", // Fallback image
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(allProducts.length, (i) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      initialCarouselIndex = i;
                    });

                    _carouselController.jumpToPage(i);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (i == initialCarouselIndex) ? Colors.white : Colors.grey,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}