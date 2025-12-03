import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EducationProgress extends StatelessWidget {
  final String userId;

  const EducationProgress({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const LinearProgressIndicator(
          value: 0.75, // Placeholder for actual progress data
          color: Colors.green,
          minHeight: 10,
        ),
        const SizedBox(height: 8),
        Text(
          'Waste Education Progress: 75%',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Text(
          'Achievements',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Wrap(
          spacing: 8,
          children: [
            const BadgeWidget(title: 'Recycling Pro'),
            EcoWarriorBadge(userId: userId),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class BadgeWidget extends StatelessWidget {
  final String title;

  const BadgeWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(title, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.green,
    );
  }
}

class EcoWarriorBadge extends StatelessWidget {
  final String userId;

  const EcoWarriorBadge({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModuleListScreen(userId: userId),
          ),
        );
      },
      child: const Chip(
        label: Text('Eco-Warrior', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class ModuleListScreen extends StatefulWidget {
  final String userId;

  const ModuleListScreen({super.key, required this.userId});

  @override
  _ModuleListScreenState createState() => _ModuleListScreenState();
}

class _ModuleListScreenState extends State<ModuleListScreen> {
  final List<Module> _modules = [
    Module(id: 1, title: 'Module 1', lessons: _sampleLessons(1), isLocked: false),
    Module(id: 2, title: 'Module 2', lessons: _sampleLessons(2), isLocked: true),
    Module(id: 3, title: 'Module 3', lessons: _sampleLessons(3), isLocked: true),
  ];

  static List<Lesson> _sampleLessons(int moduleId) {
    return [
      Lesson(
        id: 1,
        title: 'Introduction to Recycling',
        description: 'Learn about recycling basics.',
        videoUrl: 'https://www.youtube.com/watch?v=cNPEH0GOhRw',
      ),
      Lesson(
        id: 2,
        title: 'Advanced Waste Sorting',
        description: 'Sorting waste for effective recycling.',
        videoUrl: 'https://www.youtube.com/watch?v=LJYWRTRJThY&t=53s',
      ),
      Lesson(
        id: 3,
        title: 'Environmental Benefits',
        description: 'Understand the benefits of recycling.',
        videoUrl: 'https://www.youtube.com/watch?v=7j-DsONRMWI',
      ),
    ];
  }

  void _unlockModule(int moduleId) {
    setState(() {
      final moduleIndex = _modules.indexWhere((m) => m.id == moduleId);
      if (moduleIndex != -1 && moduleIndex < _modules.length - 1) {
        _modules[moduleIndex + 1] = _modules[moduleIndex + 1].copyWith(isLocked: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eco-Warrior Course Modules')),
      body: ListView.builder(
        itemCount: _modules.length,
        itemBuilder: (context, index) {
          final module = _modules[index];
          return ListTile(
            title: Text(module.title),
            trailing: module.isLocked
                ? const Icon(Icons.lock, color: Colors.grey)
                : const Icon(Icons.lock_open, color: Colors.green),
            onTap: () {
              if (!module.isLocked) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonScreen(
                      module: module,
                      onComplete: () => _unlockModule(module.id),
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class LessonScreen extends StatefulWidget {
  final Module module;
  final VoidCallback onComplete;

  const LessonScreen({super.key, required this.module, required this.onComplete});

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _currentLessonIndex = 0;

  void _completeLesson() {
    if (_currentLessonIndex < widget.module.lessons.length - 1) {
      setState(() {
        _currentLessonIndex++;
      });
    } else {
      widget.onComplete();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.module.lessons[_currentLessonIndex];
    return Scaffold(
      appBar: AppBar(title: Text(widget.module.title)),
      body: Column(
        children: [
          VideoLink(videoUrl: lesson.videoUrl),
          const SizedBox(height: 16),
          Expanded(
            child: ListTile(
              title: Text(lesson.title),
              subtitle: Text(lesson.description),
            ),
          ),
          ElevatedButton(
            onPressed: _completeLesson,
            child: Text(
              _currentLessonIndex < widget.module.lessons.length - 1 ? 'Next Lesson' : 'Complete Module',
            ),
          ),
        ],
      ),
    );
  }
}

class VideoLink extends StatelessWidget {
  final String videoUrl;

  const VideoLink({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _launchURL(videoUrl),
      child: const Text('Watch Video'),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Module {
  final int id;
  final String title;
  final List<Lesson> lessons;
  final bool isLocked;

  Module({
    required this.id,
    required this.title,
    required this.lessons,
    this.isLocked = true,
  });

  Module copyWith({bool? isLocked}) {
    return Module(
      id: id,
      title: title,
      lessons: lessons,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

class Lesson {
  final int id;
  final String title;
  final String description;
  final String videoUrl;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
  });
}
