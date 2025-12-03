import 'package:binpack_residents/utils/card.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:binpack_residents/utils/globalPadding.dart';

class EcoRangersScreen extends StatelessWidget {
  const EcoRangersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco-Rangers'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: GlobalPadding.all,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: GlobalPadding.vertical,
                child: Text(
                  'Meet Our Characters',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              EcoRangerCards(),
              const Padding(
                padding: GlobalPadding.vertical,
                child: Text(
                  'Eco Rangers Strika Entertainment 1-5',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              EcoRangersVideos(),
            ],
          ),
        ),
      ),
    );
  }
}

class EcoRangerCards extends StatelessWidget {
  final List<Map<String, String>> ecoRangers = [
    {
      'name': 'Recylco',
      'power': 'He has power over recyclable materials',
      'personality': 'Leader of the group',
      'image': 'assets/images/recyclo.png',
    },
    {
      'name': 'Litter-X',
      'power': 'Super agility and strength',
      'personality': 'Quick-witted and bold',
      'image': 'assets/images/litterx.png',
    },
    {
      'name': 'Lynx',
      'power': 'Can talk to animals',
      'personality': 'Cheeky and open-minded',
      'image': 'assets/images/lynx.png',
    },
    {
      'name': 'Sky',
      'power': 'Can control vegetation',
      'personality': 'The quiet one who gets things done',
      'image': 'assets/images/sky.png',
    },
  ];

  EcoRangerCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: GlobalPadding.horizontal,
      child: CardList(
        cards: ecoRangers.map((ranger) {
          return Padding(
            padding: GlobalPadding.all,
            child: Row(
              children: [
                Image.asset(
                  ranger['image']!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ranger['name']!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Power: ${ranger['power']}'),
                      const SizedBox(height: 4),
                      Text('Personality: ${ranger['personality']}'),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class EcoRangersVideos extends StatelessWidget {
  final List<String> videoUrls = [
    'assets/videos/video1.mp4',
    'assets/videos/video2.mp4',
    'assets/videos/video3.mp4',
    'assets/videos/video4.mp4',
    'assets/videos/video5.mp4',
  ];

  EcoRangersVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: GlobalPadding.horizontal,
      child: Column(
        children: videoUrls.map((videoUrl) {
          return CustomCard(
            child: EcoRangerVideoPlayer(videoUrl: videoUrl),
          );
        }).toList(),
      ),
    );
  }
}

class EcoRangerVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const EcoRangerVideoPlayer({super.key, required this.videoUrl});

  @override
  _EcoRangerVideoPlayerState createState() => _EcoRangerVideoPlayerState();
}

class _EcoRangerVideoPlayerState extends State<EcoRangerVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_controller.value.isInitialized)
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () {
                setState(() {
                  _controller.pause();
                  _controller.seekTo(Duration.zero);
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
