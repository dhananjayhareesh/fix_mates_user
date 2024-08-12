import 'package:fix_mates_user/resources/constants/textstyle.dart';
import 'package:fix_mates_user/resources/strings/hometext.dart';
import 'package:fix_mates_user/resources/widgets/homescreen_widget/carosal_widget.dart';
import 'package:flutter/material.dart';
import 'package:fix_mates_user/resources/widgets/homescreen_widget/homescreen_appbar_widget.dart';
import 'package:fix_mates_user/resources/widgets/homescreen_widget/homescreen_grid_widget.dart';
import 'package:fix_mates_user/resources/widgets/homescreen_widget/searchbar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String?>> gridItems = [
      {
        'image': 'assets/electric.png',
        'title': 'Electrical',
        'category': 'Electrical'
      },
      {'image': 'assets/fridge.png', 'title': 'Fridge', 'category': 'Fridge'},
      {
        'image': 'assets/ac.png',
        'title': 'Air condition',
        'category': 'Air condition'
      },
      {
        'image': 'assets/handyman.png',
        'title': 'Handyman',
        'category': 'Handyman'
      },
      {'image': 'assets/mop.png', 'title': 'Cleaning', 'category': 'Cleaning'},
      {
        'image': 'assets/plumbing.png',
        'title': 'Plumbing',
        'category': 'Plumbing'
      },
      {
        'image': 'assets/wm.png',
        'title': 'Washing Machine',
        'category': 'Washing Machine'
      },
      {
        'image': 'assets/painting.png',
        'title': 'Painting',
        'category': 'Painting'
      },
    ];

    final List<String> bannerImages = [
      'assets/carosal_electricaion.jpg',
      'assets/elecmech.webp',
      'assets/acmech.jpg',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomSearchBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: CarouselBanner(
                bannerImages: bannerImages,
                bannerTitle: '',
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  HomeText.allServices,
                  style: AppText.averageblack,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: gridItems.length,
                itemBuilder: (context, index) {
                  final item = gridItems[index];
                  return GridItem(
                    imagePath: item['image'],
                    title: item['title'],
                    category: item['category'],
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  HomeText.popularServices,
                  style: AppText.averageblack,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 10.0,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final item = gridItems[index];
                  return GridItem(
                    imagePath: item['image'],
                    title: item['title'],
                    category: item['category'],
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.center,
              child: Text(
                HomeText.happiness,
                style: AppText.averageblack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
