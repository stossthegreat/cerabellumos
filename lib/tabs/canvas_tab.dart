import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/projects_provider.dart';
import '../widgets/glassmorphic_card.dart';
import '../widgets/add_project_dialog.dart';
import '../screens/settings_screen.dart';

class CanvasTab extends StatefulWidget {
  const CanvasTab({super.key});

  @override
  State<CanvasTab> createState() => _CanvasTabState();
}

class _CanvasTabState extends State<CanvasTab> {
  bool _sidebarOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // MAIN CONTENT
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildMainCanvas(context),
              ),
              _buildInputArea(context),
            ],
          ),
          
          // SIDEBAR
          if (_sidebarOpen)
            GestureDetector(
              onTap: () => setState(() => _sidebarOpen = false),
              child: Container(
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _sidebarOpen ? 0 : -320,
            top: 0,
            bottom: 0,
            width: 320,
            child: _buildSidebar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final projectsProvider = context.watch<ProjectsProvider>();
    final activeProject = projectsProvider.activeProject;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827).withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: () => setState(() => _sidebarOpen = !_sidebarOpen),
              icon: const Icon(
                LucideIcons.panelLeft,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: activeProject != null
                  ? Row(
                      children: [
                        Text(
                          activeProject.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activeProject.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'ELITE AI TUTOR',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const Row(
                      children: [
                        Icon(
                          LucideIcons.sparkles,
                          color: Color(0xFF8B5CF6),
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'SELECT SESSION',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
              icon: const Icon(
                LucideIcons.settings,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final projectsProvider = context.watch<ProjectsProvider>();
    final projects = projectsProvider.projects;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF111827).withOpacity(0.95),
            Colors.black.withOpacity(0.95),
          ],
        ),
        border: Border(
          right: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'AI SESSIONS',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _sidebarOpen = false),
                          icon: Icon(
                            LucideIcons.x,
                            color: Colors.grey.shade400,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        setState(() => _sidebarOpen = false);
                        showDialog(
                          context: context,
                          builder: (context) => const AddProjectDialog(),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.plus,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'NEW SESSION',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Projects List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  final isActive = projectsProvider.activeProjectId == project.id;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () {
                        projectsProvider.setActiveProject(project.id);
                        setState(() => _sidebarOpen = false);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: isActive
                              ? LinearGradient(
                                  colors: [
                                    const Color(0xFF8B5CF6).withOpacity(0.5),
                                    const Color(0xFF6D28D9).withOpacity(0.5),
                                  ],
                                )
                              : null,
                          border: Border.all(
                            color: isActive
                                ? const Color(0xFF8B5CF6).withOpacity(0.8)
                                : Colors.transparent,
                          ),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF8B5CF6).withOpacity(0.3),
                                    blurRadius: 12,
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          children: [
                            Text(
                              project.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${project.power}/10 POWER',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
            ],
          ),
      ),
    );
  },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCanvas(BuildContext context) {
    final projectsProvider = context.watch<ProjectsProvider>();
    final activeProject = projectsProvider.activeProject;

    return Container(
      color: Colors.black,
      child: activeProject == null
          ? _buildEmptyState(context)
          : _buildChatArea(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                ),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withOpacity(0.8),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.6),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                LucideIcons.brain,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'NEURAL INTERFACE READY',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ask anything. I\'m locked in and ready to dominate.',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ...[
              'Destroy this chemistry topic',
              'Quiz me until I master it',
              'Find my weak spots NOW',
              'Generate ultimate study plan',
            ].map((prompt) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Set input value
                    },
                    child: GlassmorphicCard(
                      padding: const EdgeInsets.all(16),
                      borderColor: Colors.white.withOpacity(0.2),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.sparkles,
                            color: Color(0xFF8B5CF6),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              prompt,
                              style: TextStyle(
                                color: Colors.grey.shade200,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildChatArea(BuildContext context) {
    // Placeholder for future chat implementation
    return Center(
      child: Text(
        'Chat interface coming soon',
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111827).withOpacity(0.8),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: Icon(
                LucideIcons.camera,
                color: Colors.grey.shade400,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  'DROP YOUR QUESTIONS HERE...',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFDC2626), Color(0xFFEC4899)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFDC2626).withOpacity(0.5),
                ),
              ),
              child: const Icon(
                LucideIcons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

