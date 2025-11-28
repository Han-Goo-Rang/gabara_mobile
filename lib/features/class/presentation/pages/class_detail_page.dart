import 'package:flutter/material.dart';
import '../../domain/entities/class_entity.dart';
import '../widgets/class_tabs_dummy.dart'; 
import '../../../../core/constants/app_colors.dart';

class ClassDetailPage extends StatefulWidget {
  final ClassEntity classEntity;

  const ClassDetailPage({super.key, required this.classEntity});

  @override
  State<ClassDetailPage> createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: primaryBlue,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 60),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image (Peta Merah dummy)
                    Image.asset(
                      'assets/indonesia.png', 
                      fit: BoxFit.cover,
                      color: Colors.red.withOpacity(0.8),
                      colorBlendMode: BlendMode.srcATop,
                      errorBuilder: (ctx, err, stack) => Container(color: primaryBlue),
                    ),
                    // Overlay Gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    // Info Kelas
                    Positioned(
                      bottom: 60,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "2025/2026",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.classEntity.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.classEntity.tutorName,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: const [
                  Tab(text: "Kursus"),
                  Tab(text: "Peserta"),
                  Tab(text: "Diskusi"),
                  Tab(text: "Nilai"),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: const [
            ClassCourseTab(),
            ClassParticipantsTab(),
            ClassDiscussionTab(),
            ClassGradesTab(),
          ],
        ),
      ),
    );
  }
}