import 'package:flutter/material.dart';
import 'package:mediabooster/screen/audio_player_component.dart';
import 'package:mediabooster/screen/carousel_slider.dart';
import 'package:mediabooster/screen/video_player_component.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: const [
          AudioPlayerComponent(),
          VideoPlayerComponent(),
          CarouselSliderComponent(),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(icon: Icon(Icons.audiotrack), text: "Audio Player"),
          Tab(icon: Icon(Icons.video_collection), text: "Video Player"),
          Tab(icon: Icon(Icons.apps), text: "Carousel View"),
        ],
      ),
    );
  }
}
