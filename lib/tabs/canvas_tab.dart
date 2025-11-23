import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/projects_provider.dart';
import '../widgets/glassmorphic_card.dart';
import '../widgets/add_project_dialog.dart';
import '../screens/settings_screen.dart';
import '../services/api_service.dart';

class CanvasTab extends StatefulWidget {
  const CanvasTab({super.key});

  @override
  State<CanvasTab> createState() => _CanvasTabState();
}

class _CanvasTabState extends State<CanvasTab> {
  bool _sidebarOpen = false;
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Store messages per project ID
  final Map<String, List<ChatMessage>> _projectMessages = {};
  bool _isLoading = false;
  
  // Get messages for current project
  List<ChatMessage> get _messages {
    final projectsProvider = context.read<ProjectsProvider>();
    final activeProject = projectsProvider.activeProject;
    if (activeProject == null) return [];
    
    // Initialize project messages if not exists
    _projectMessages[activeProject.id] ??= [];
    return _projectMessages[activeProject.id]!;
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    print('🔵 [NEURAL] Sending message: ${text.substring(0, text.length > 50 ? 50 : text.length)}...');

    final projectsProvider = context.read<ProjectsProvider>();
    final activeProject = projectsProvider.activeProject;

    // Determine project ID
    String projectId;
    try {
      if (activeProject == null) {
        print('🔵 [NEURAL] No active project, creating "General Chat"...');
        // Create default project
        await projectsProvider.createProject(
          name: 'General Chat',
          emoji: '💬',
        );
        print('🔵 [NEURAL] Project created');
        final newProject = projectsProvider.projects.first;
        projectsProvider.setActiveProject(newProject.id);
        projectId = newProject.id;
        print('🔵 [NEURAL] Project ID: $projectId');
      } else {
        projectId = activeProject.id;
        print('🔵 [NEURAL] Using existing project ID: $projectId');
      }
    } catch (e, stackTrace) {
      print('❌ [NEURAL] Failed to create/get project: $e');
      print('❌ [NEURAL] Stack: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create chat: $e'),
            backgroundColor: const Color(0xFFDC2626),
            duration: const Duration(seconds: 5),
          ),
        );
      }
      return;
    }

    // Initialize project messages if needed
    _projectMessages[projectId] ??= [];

    // Add user message to THIS project's chat
    setState(() {
      _projectMessages[projectId]!.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });
    _inputController.clear();
    _scrollToBottom();

    try {
      print('🔵 [NEURAL] Calling ApiService.sendMessage...');
      // Send to backend
      final response = await ApiService.sendMessage(
        projectId,
        text,
      );
      print('🔵 [NEURAL] Got response: ${response['reply']?.substring(0, 50)}...');

      // Add AI response to THIS project's chat
      setState(() {
        _projectMessages[projectId]!.add(ChatMessage(
          text: response['reply'] ?? 'No response',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e, stackTrace) {
      print('❌ [NEURAL] sendMessage failed: $e');
      print('❌ [NEURAL] Stack: $stackTrace');
      
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: const Color(0xFFDC2626),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _sendPresetMessage(String message) {
    _inputController.text = message;
    _sendMessage();
  }

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
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activeProject.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'AI Assistant',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Icon(
                          LucideIcons.messageSquare,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Select or create a chat',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade400,
                            fontSize: 15,
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
                    ),
                  );
                },
              ),
            ),
          ],
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF0EA5E9).withOpacity(0.15),
                border: Border.all(
                  color: const Color(0xFF0EA5E9).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                LucideIcons.messageSquare,
                color: Color(0xFF0EA5E9),
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'AI Study Assistant',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Get instant help with any topic or question',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ...[
              {'icon': LucideIcons.bookOpen, 'text': 'Explain this concept clearly'},
              {'icon': LucideIcons.listChecks, 'text': 'Create practice questions'},
              {'icon': LucideIcons.target, 'text': 'Identify knowledge gaps'},
              {'icon': LucideIcons.zap, 'text': 'Generate study plan'},
            ].map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => _sendPresetMessage(item['text'] as String),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0EA5E9).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              item['icon'] as IconData,
                              color: const Color(0xFF0EA5E9),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              item['text'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Icon(
                            LucideIcons.arrowRight,
                            color: Colors.grey.shade600,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildChatArea(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Messages
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.messageSquare,
                          color: Colors.grey.shade700,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Start a conversation',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(24),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessage(message);
                    },
                  ),
          ),
          
          // Loading indicator
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI is thinking...',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                LucideIcons.brain,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: message.isUser
                    ? const LinearGradient(
                        colors: [Color(0xFFDC2626), Color(0xFFEC4899)],
                      )
                    : null,
                color: message.isUser ? null : Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: message.isUser
                      ? const Color(0xFFDC2626).withOpacity(0.5)
                      : Colors.white.withOpacity(0.1),
                ),
              ),
              child: Text(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ),
          ),
          
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFDC2626), Color(0xFFEC4899)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                LucideIcons.user,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ],
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
            GestureDetector(
              onTap: () {
                // TODO: Implement camera
              },
              child: Container(
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
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _inputController,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'DROP YOUR QUESTIONS HERE...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF8B5CF6),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

